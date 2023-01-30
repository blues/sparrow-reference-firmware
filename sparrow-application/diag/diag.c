// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "diag.h"

// Standard Library
#include <malloc.h>

// ST Header(s)
#include <main.h>  // ST system function declarations

// Blues Header(s)
#include <framework.h>
#include <note.h>

// States for the local state machine
#define STATE_DIAG_ABORT       0
#define STATE_DIAG_CHECK       1
#define STATE_DIAG_ISR_XFER    2

// Special request IDs
#define REQUESTID_DIAGNOTE     9171979
#define REQUESTID_TEMPLATE     19790917

#define ISR_MAX_CALL_RETENTION 8  // Must be a power of 2
#define ISR_COUNTER_MASK       (ISR_MAX_CALL_RETENTION - 1)

// The dynamic filename of the application specific queue.
// NOTE: The Gateway will replace `*` with the originating node's ID.
#define APPLICATION_NOTEFILE   "*#diag.qo"

typedef struct isrParameters {
    int appID;
    uint16_t pins;
} isrParameters;

typedef struct applicationContext {
    // ISR call ring-buffer
    volatile size_t isrCount;
    volatile bool isrOverflow;
    isrParameters isrParams[ISR_MAX_CALL_RETENTION];

    // Application status
    bool templateRegistered;  // Only `true` once we've successfully registered the template
    bool done;
} applicationContext;

// Forwards
static void addDiagnosticNote(bool immediate);
static const char * diagStateName (int state);
static bool registerNotefileTemplate(void);
static inline void resetIsrValues(applicationContext *ctx);

// Application Activation (on wake)
bool diagActivate(int appID, void *appContext)
{
    // Load Application Context
    applicationContext *ctx = appContext;

    APP_PRINTF("diag: Entered application callback function: diagActivate\r\n\tappId: %d\r\n", appID);
    ctx->done = false;

    // Success
    return true;
}

// Scheduled App One-Time Init
bool diagInit(void)
{
    APP_PRINTF("diag: Initializing application...\r\n");
    bool result = false;

    // Allocate and initialize application context
    applicationContext *ctx = (applicationContext *)malloc(sizeof(applicationContext));
    ctx->templateRegistered = false;
    ctx->done = false;
    resetIsrValues(ctx);

    // Register the application
    schedAppConfig config = {
        .name = "diagnostic",
        .activationPeriodSecs = 60 * 10,
        .pollPeriodSecs = 5,
        .activateFn = diagActivate,
        .interruptFn = diagISR,
        .pollFn = diagPoll,
        .responseFn = diagResponse,
        .appContext = ctx,
    };
    if (schedRegisterApp(&config) < 0) {
        // Failure
        result = false;
    } else {
        // Success
        result = true;
    }

    return result;
}

// Interrupt handler
void diagISR(int appID, uint16_t pins, void *appContext)
{
    // Load Application Context
    applicationContext *ctx = appContext;

    /*
     * This callback function is executed directly from the ISR.
     * Only perform ISR sensitive operations and exit quickly.
     */
    ctx->isrParams[ctx->isrCount].appID = appID;
    ctx->isrParams[ctx->isrCount].pins = pins;
    ctx->isrCount++;
    ctx->isrCount = (ISR_COUNTER_MASK & ctx->isrCount);
    ctx->isrOverflow = (ctx->isrOverflow || !ctx->isrCount);

	if ((pins & BUTTON1_Pin) && !schedIsActive(appID)) {
        schedActivateNowFromISR(appID, true, STATE_DIAG_ISR_XFER);
    }
}

// Poller
void diagPoll(int appID, int state, void *appContext)
{
    // Load Application Context
    applicationContext *ctx = appContext;

    APP_PRINTF("diag: Entered application callback function: diagPoll\r\n\tappId: %d\tstate: %s\r\n", appID, diagStateName(state));

    // Switch based upon state
    switch (state) {
    case STATE_ACTIVATED:
        if (!ctx->templateRegistered) {
            registerNotefileTemplate();
            schedSetCompletionState(appID, STATE_DIAG_CHECK, STATE_DIAG_ABORT);
        } else {
            schedSetState(appID, STATE_DIAG_CHECK, "diag: process diagnostics");
        }
        break;

    case STATE_DIAG_ISR_XFER:
        APP_PRINTF("diag: Transfered from application ISR callback function.\r\n");
        APP_PRINTF("diag: ISR callback function called %s<%d> time(s).\r\n", (ctx->isrOverflow ? "more than " : ""), (ctx->isrOverflow ? ISR_MAX_CALL_RETENTION : ctx->isrCount));
        if (ctx->isrOverflow) { ctx->isrCount = ISR_MAX_CALL_RETENTION; }
        for (size_t i = 0 ; i < ctx->isrCount ; ++i) {
            APP_PRINTF("diag: call %d:\tappId: %d\tpins: %d\r\n", i, ctx->isrParams[i].appID, ctx->isrParams[i].pins);
        }
        resetIsrValues(ctx);
        // fall through and report diagnostics

    case STATE_DIAG_CHECK:
        if (ctx->done) {
            schedSetState(appID, STATE_DEACTIVATED, "diag: completed successfully");
            break;
        }
        addDiagnosticNote(true);
        schedSetCompletionState(appID, STATE_DIAG_CHECK, STATE_DIAG_ABORT);
        break;

    case STATE_DIAG_ABORT:
        schedSetState(appID, STATE_DEACTIVATED, "diag: aborted due to failure!");
        break;

    default:
        ;
    }
}

// Gateway Response handler
void diagResponse(int appID, J *rsp, void *appContext)
{
    // Load Application Context
    applicationContext *ctx = appContext;

    APP_PRINTF("diag: Entered application callback function: diagResponse\r\n\tappId: %d", appID);
    char *json_string = JConvertToJSONString(rsp);
    APP_PRINTF("\trsp: %s\r\n", json_string);
    free(json_string);

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("diag: gateway returned error: %s\r\n", err);
        schedSetState(appID, STATE_DIAG_ABORT, "diag: aborting...");
        return;
    }

    // Flash the LED if this is a response to this specific ping request
    switch (JGetInt(rsp, "id")) {
    case REQUESTID_DIAGNOTE:
        ctx->done = true;
        APP_PRINTF("diag: SUCCESSFUL Note submission\r\n");
        break;
    case REQUESTID_TEMPLATE:
        ctx->templateRegistered = true;
        APP_PRINTF("diag: SUCCESSFUL template registration\r\n");
        break;
    default:
        ;
        APP_PRINTF("diag: received unexpected response\r\n");
    }
}

// Send the application data
static void addDiagnosticNote(bool immediate)
{
    APP_PRINTF("diag: generating diagnostic report\r\n");

    // Create the request
    J *req = NoteNewRequest("note.add");
    if (req == NULL) {
        return;
    }

    // If immediate, sync now
    if (immediate) {
        JAddBoolToObject(req, "sync", true);
    }

    // Set the target notefile
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

    // Add an ID to the request, which will be echo'ed
    // back in the response by the notecard itself.  This
    // helps us to identify the asynchronous response
    // without needing to have an additional state.
    JAddNumberToObject(req, "id", REQUESTID_DIAGNOTE);

    // Create the body
    J *body = JAddObjectToObject(req, "body");
    if (body == NULL) {
        JDelete(req);
        return;
    }

    // Fill-in the body
    struct mallinfo mem_info = mallinfo();

    JAddNumberToObject(body, "mem.alloc.bytes", (JNUMBER)mem_info.uordblks);
    JAddNumberToObject(body, "mem.free.bytes", (JNUMBER)mem_info.fordblks);
    JAddNumberToObject(body, "mem.heap.bytes", (JNUMBER)MX_Heap_Size(NULL));
#ifdef USE_SPARROW
    JAddNumberToObject(body, "voltage", (JNUMBER)MX_ADC_A0_Voltage());
#endif

    // Send request to the gateway
    noteSendToGatewayAsync(req, true);
    APP_PRINTF("diag: note request sent\r\n");
}

static inline const char * diagStateName (int state)
{
    switch (state) {
    case STATE_DIAG_ABORT:
        return "DIAG_ABORT";
    case STATE_DIAG_CHECK:
        return "DIAG_CHECK";
    case STATE_DIAG_ISR_XFER:
        return "DIAG_ISR_XFER";
    default:
    {
        static char undefined_state[20];
        schedStateName(state, undefined_state, sizeof(undefined_state));
        return undefined_state;
    }
    }
}

// Register the notefile template for our data
static bool registerNotefileTemplate()
{
    APP_PRINTF("diag: template registration request\r\n");

    // Create the request
    J *req = NoteNewRequest("note.template");
    if (req == NULL) {
        return false;
    }

    // Fill-in request parameters.  Note that in order to minimize
    // the size of the over-the-air JSON we're using a special format
    // for the "file" parameter implemented by the gateway, in which
    // a "file" parameter beginning with * will have that character
    // substituted with the textified Sparrow node address.
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

    // Add an ID to the request, which will be echo'ed
    // back in the response by the notecard itself.  This
    // helps us to identify the asynchronous response
    // without needing to have an additional state.
    JAddNumberToObject(req, "id", REQUESTID_TEMPLATE);

    // Create the body
    J *body = JAddObjectToObject(req, "body");
    if (body == NULL) {
        JDelete(req);
        return false;
    }

    // Fill-in the body template
    JAddNumberToObject(body, "mem.alloc.bytes", TINT32);
    JAddNumberToObject(body, "mem.free.bytes", TINT32);
    JAddNumberToObject(body, "mem.heap.bytes", TINT32);
    JAddNumberToObject(body, "voltage", TFLOAT32);

    // Send request to the gateway
    noteSendToGatewayAsync(req, true);
    return true;
}

// Reset the ISR field values
static inline void resetIsrValues(applicationContext *ctx)
{
    APP_PRINTF("diag: resetting ISR values\r\n");

    ctx->isrCount = 0;
    ctx->isrOverflow = false;
    for (size_t i = 0 ; i < ISR_MAX_CALL_RETENTION ; ++i) {
        ctx->isrParams[i].appID = 0;
        ctx->isrParams[i].pins = 0;
    }
}
