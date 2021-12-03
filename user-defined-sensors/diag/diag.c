/*
 * Compile Command:
 * gcc diag.c -c -D CORE_CM4 -D STM32WL55xx -I sparrow-lora/Application/ -I sparrow-lora/Application/App/ -I sparrow-lora/Application/Sensor/ -I sparrow-lora/Application/Core/Inc/ -I sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include/ -I sparrow-lora/Drivers/CMSIS/Include/ -I sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc/ -I sparrow-lora/note-c/ -I sparrow-lora/Utilities/misc -I sparrow-lora/Utilities/trace/adv_trace/ -I sparrow-lora/Utilities/timer/ -o diag.o
 */

#include "diag.h"

// Sparrow Header(s)
#include <sensor.h>

// ST Header(s)
#include <main.h>  // ST system function declarations

// States for the local state machine
#define STATE_DIAG_CHECK            0
#define STATE_DIAG_ISR_XFER         1

// Special request IDs
#define REQUESTID_TEMPLATE          2

// The filename of the test database.  Note that * is replaced by the
// gateway with the sensor's ID, while the # is a special character
// reserved by the notecard and notehub for a Sensor ID that is
// appended to the device ID within Events.
#define SENSORDATA_NOTEFILE         "*#diag.qo"

typedef struct ISR_parameters {
    int sensorID;
    uint16_t pins;
} ISR_parameters;

// Call ring-buffer
volatile size_t isr_count = 0;
volatile bool isr_overflow = false;
ISR_parameters isr_params[8];

// TRUE if we've successfully registered the template
static bool templateRegistered = false;
static bool done = false;

// Forwards
static void addNote(bool immediate);
static bool registerNotefileTemplate(void);

// Our sensor ID
static int sensorID = -1;

// Sensor Activation (on wake)
bool diagActivate(int sensorID)
{
    APP_PRINTF("diag: Entered sensor callback function: %s\r\n\tsensorId: %d\r\n", __FUNCTION__, sensorID);
    done = false;

    // Success
    return true;
}

// Sensor One-Time Init
bool diagInit(void)
{
    APP_PRINTF("diag: Entered sensor callback function: %s\r\n", __FUNCTION__);
    bool result = false;

    // Register the sensor
    sensorConfig config = {
        .name = "diagnostic",
        .activationPeriodSecs = 60 * 5,
        .pollIntervalSecs = 5,
        .activateFn = diagActivate,
        .interruptFn = diagISR,
        .pollFn = diagPoll,
        .responseFn = diagResponse,
    };
    sensorID = schedRegisterSensor(&config);
    if (sensorID < 0) {
        // Failure
        result = false;
    } else {
        // Success
        result = true;
    }

    return result;
}

// Interrupt handler
void diagISR(int sensorID, uint16_t pins)
{
    /*
     * This callback function is executed directly from the ISR.
     * Only perform ISR sensitive operations and exit quickly.
     */
    isr_params[isr_count].sensorID = sensorID;
    isr_params[isr_count].pins = pins;
    isr_count = (~0xFFFFFFF8 & ++isr_count);
    isr_overflow = !isr_count;

	if (!schedIsActive(sensorID) && (pins & BUTTON1_Pin)) {
        schedActivateNowFromISR(sensorID, true, STATE_DIAG_ISR_XFER);
    }

	return;
}

// Poller
void diagPoll(int sensorID, int state)
{
    APP_PRINTF("diag: Entered sensor callback function: %s\r\n\tsensorId: %d\tstate: %s\r\n", __FUNCTION__, sensorID, schedStateName(state));
//    if (appSKU() != SKU_REFERENCE) {
//    	schedDisable(sensorID);
//    }

    // Switch based upon state
    switch (state) {
    case STATE_ACTIVATED:
        if (!templateRegistered) {
            registerNotefileTemplate();
            schedSetCompletionState(sensorID, STATE_DIAG_CHECK, STATE_ACTIVATED);
            APP_PRINTF("diag: template registration request\r\n");
        } else {
            schedSetState(sensorID, STATE_DIAG_CHECK, "diag: process diagnostics");
        }
        break;

    case STATE_DIAG_ISR_XFER:
        APP_PRINTF("diag: Transfered from sensor ISR callback function.\r\n");
        APP_PRINTF("diag: ISR callback function called %s <%d> times.\r\n", (isr_overflow ? "more than" : ""), (isr_overflow ? 8 : isr_count));
        for (size_t i = 0 ; i < isr_count ; ++i) {
            APP_PRINTF("diag: call %d:\tsensorId: %d\tpins: %d\r\n", i, isr_params[i].sensorID, isr_params[i].pins);
        }
        isr_count = 0;
        isr_overflow = false;
        // fall through to do a report diagnostics

    case STATE_DIAG_CHECK:
        if (done) {
            schedSetState(sensorID, STATE_DEACTIVATED, "diag: completed");
            break;
        }
        APP_PRINTF("diag: generating diagnostic report\r\n");
        addNote(true);
        schedSetCompletionState(sensorID, STATE_DIAG_CHECK, STATE_DIAG_CHECK);
        APP_PRINTF("diag: note queued\r\n");
        done = true;
        break;
    }
}

// Gateway Response handler
void diagResponse(int sensorID, J *rsp)
{
    APP_PRINTF("diag: Entered sensor callback function: %s\r\n\tsensorId: %d\trsp: %s\r\n", __FUNCTION__, sensorID, JConvertToJSONString(rsp));

    // If this is a response timeout, indicate as such
    if (rsp == NULL) {
        APP_PRINTF("diag: response timeout\r\n");
        return;
    }

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("sensor error response: %d\r\n", err);
        return;
    }

    // Flash the LED if this is a response to this specific ping request
    switch (JGetInt(rsp, "id")) {

    case REQUESTID_TEMPLATE:
        templateRegistered = true;
        APP_PRINTF("diag: SUCCESSFUL template registration\r\n");
        break;
    }
}

// Send the sensor data
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
    JAddStringToObject(req, "file", SENSORDATA_NOTEFILE);

    // Fill-in the body
    JAddNumberToObject(body, "mem.heap.bytes", (JNUMBER)MX_Heap_Size(NULL));

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
    // substituted with the textified sensor address.
    JAddStringToObject(req, "file", SENSORDATA_NOTEFILE);

    // Fill-in the body template
    JAddNumberToObject(body, "mem.heap.bytes", TINT32);

    // Send request to the gateway
    noteSendToGatewayAsync(req, true);
    return true;
}
