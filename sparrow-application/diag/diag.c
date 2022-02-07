// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "diag.h"

// Sparrow Header(s)
#include <framework.h>

// ST Header(s)
#include <main.h>  // ST system function declarations

// States for the local state machine
#define STATE_DIAG_CHECK       0
#define STATE_DIAG_ISR_XFER    1

// Special request IDs
#define REQUESTID_TEMPLATE     2

#define ISR_MAX_CALL_RETENTION 8
#define ISR_COUNTER_MASK       ~0xFFFFFFF8

// The filename of the test database.  Note that * is replaced by the
// gateway with the Sparrow node's ID, while the # is a special character
// reserved by the Notecard and Notehub for a Scheduled App ID that is
// appended to the device ID within Events.
#define APPLICATION_NOTEFILE "*#" __FILENAME__ ".qo"

typedef struct ISR_parameters {
    int appID;
    uint16_t pins;
} ISR_parameters;

// ISR call ring-buffer
static volatile size_t isr_count = 0;
static volatile bool isr_overflow = false;
static ISR_parameters isr_params[ISR_MAX_CALL_RETENTION];

// TRUE if we've successfully registered the template
static bool templateRegistered = false;
static bool done = false;

// Forwards
static void addNote(bool immediate);
static bool registerNotefileTemplate(void);

// Our scheduled app's ID
static int appID = -1;

// Application Activation (on wake)
bool diagActivate(int appID)
{
    APP_PRINTF("diag: Entered application callback function: diagActivate\r\n\tappId: %d\r\n", appID);
    done = false;

    // Success
    return true;
}

// Scheduled App One-Time Init
bool diagInit(void)
{
    APP_PRINTF("diag: Initializing application...\r\n");
    bool result = false;

    // Register the application
    schedAppConfig config = {
        .name = "diagnostic",
        .activationPeriodSecs = 60 * 5,
        .pollIntervalSecs = 5,
        .activateFn = diagActivate,
        .interruptFn = diagISR,
        .pollFn = diagPoll,
        .responseFn = diagResponse,
    };
    appID = schedRegisterApp(&config);
    if (appID < 0) {
        // Failure
        result = false;
    } else {
        // Success
        result = true;
    }

    return result;
}

// Interrupt handler
void diagISR(int appID, uint16_t pins)
{
    /*
     * This callback function is executed directly from the ISR.
     * Only perform ISR sensitive operations and exit quickly.
     */
    isr_params[isr_count].appID = appID;
    isr_params[isr_count].pins = pins;
    ++isr_count;
    isr_count = (ISR_COUNTER_MASK & isr_count);
    isr_overflow = (isr_overflow || !isr_count);

	if (!schedIsActive(appID) && (pins & BUTTON1_Pin)) {
        schedActivateNowFromISR(appID, true, STATE_DIAG_ISR_XFER);
    }
}

// Poller
void diagPoll(int appID, int state)
{
    APP_PRINTF("diag: Entered application callback function: diagPoll\r\n\tappId: %d\tstate: %s\r\n", appID, schedStateName(state));

    // Switch based upon state
    switch (state) {
    case STATE_ACTIVATED:
        if (!templateRegistered) {
            registerNotefileTemplate();
            schedSetCompletionState(appID, STATE_DIAG_CHECK, STATE_ACTIVATED);
            APP_PRINTF("diag: template registration request\r\n");
        } else {
            schedSetState(appID, STATE_DIAG_CHECK, "diag: process diagnostics");
        }
        break;

    case STATE_DIAG_ISR_XFER:
        APP_PRINTF("diag: Transfered from application ISR callback function.\r\n");
        APP_PRINTF("diag: ISR callback function called %s <%d> times.\r\n", (isr_overflow ? "more than" : ""), (isr_overflow ? ISR_MAX_CALL_RETENTION : isr_count));
        for (size_t i = 0 ; i < isr_count ; ++i) {
            APP_PRINTF("diag: call %d:\tappId: %d\tpins: %d\r\n", i, isr_params[i].appID, isr_params[i].pins);
        }
        isr_count = 0;
        isr_overflow = false; // fall through
        // now report diagnostics

    case STATE_DIAG_CHECK:
        if (done) {
            schedSetState(appID, STATE_DEACTIVATED, "diag: completed");
            break;
        }
        APP_PRINTF("diag: generating diagnostic report\r\n");
        addNote(true);
        schedSetCompletionState(appID, STATE_DIAG_CHECK, STATE_DIAG_CHECK);
        APP_PRINTF("diag: note queued\r\n");
        done = true;
        break;
    default:
        ;
    }
}

// Gateway Response handler
void diagResponse(int appID, J *rsp)
{
    APP_PRINTF("diag: Entered application callback function: diagResponse\r\n\tappId: %d\trsp: %s\r\n", appID, JConvertToJSONString(rsp));

    // If this is a response timeout, indicate as such
    if (rsp == NULL) {
        APP_PRINTF("diag: response timeout\r\n");
        return;
    }

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("diag: app error response: %d\r\n", err);
        return;
    }

    // Flash the LED if this is a response to this specific ping request
    switch (JGetInt(rsp, "id")) {

    case REQUESTID_TEMPLATE:
        templateRegistered = true;
        APP_PRINTF("diag: SUCCESSFUL template registration\r\n");
        break;
    default:
        ;
    }
}

// Send the application data
static void addNote(bool immediate)
{
    // Create the request
    J *req = NoteNewRequest("note.add");
    if (req == NULL) {
        return;
    }

    // Create the body
    J *body = JAddObjectToObject(req, "body");
    if (body == NULL) {
        JDelete(req);
        return;
    }

    // If immediate, sync now
    if (immediate) {
        JAddBoolToObject(req, "sync", true);
    }

    // Set the target notefile
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

    // Fill-in the body
    JAddNumberToObject(body, "mem.heap.bytes", (JNUMBER)MX_Heap_Size(NULL));
    JAddNumberToObject(body, "voltage", (JNUMBER)MX_ADC_A0_Voltage());

    // Send request to the gateway
    noteSendToGatewayAsync(req, false);
}

// Register the notefile template for our data
static bool registerNotefileTemplate()
{
    // Create the request
    J *req = NoteNewRequest("note.template");
    if (req == NULL) {
        return false;
    }

    // Create the body
    J *body = JAddObjectToObject(req, "body");
    if (body == NULL) {
        JDelete(req);
        return false;
    }

    // Add an ID to the request, which will be echo'ed
    // back in the response by the notecard itself.  This
    // helps us to identify the asynchronous response
    // without needing to have an additional state.
    JAddNumberToObject(req, "id", REQUESTID_TEMPLATE);

    // Fill-in request parameters.  Note that in order to minimize
    // the size of the over-the-air JSON we're using a special format
    // for the "file" parameter implemented by the gateway, in which
    // a "file" parameter beginning with * will have that character
    // substituted with the textified Sparrow node address.
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

    // Fill-in the body template
    JAddNumberToObject(body, "mem.heap.bytes", TINT32);

    // Send request to the gateway
    noteSendToGatewayAsync(req, true);
    return true;
}
