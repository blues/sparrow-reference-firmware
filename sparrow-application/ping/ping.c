// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "ping.h"

// Blues Header(s)
#include <framework.h>
#include <note.h>

// If TRUE, we're in survey mode in which the button is used to send
// pings that include RSSI/SNR transmitted at full power, and all
// scheduled activities are disabled.
#define SURVEY_MODE                 false

// States for the local state machine
#define STATE_BUTTON          0

// Special request IDs
#define REQUESTID_MANUAL_PING 1
#define REQUESTID_TEMPLATE    2

// The dynamic filename of the application specific queue.
// NOTE: The Gateway will replace `*` with the originating node's ID.
#define APPLICATION_NOTEFILE  "*#data.qo"

// TRUE if we've successfully registered the template
#if !SURVEY_MODE
static bool templateRegistered = false;
#endif

// Our scheduled app's ID
static int appID = -1;

// Forwards
static bool sendHealthLogMessage(bool immediate);
#if !SURVEY_MODE
static void addNote(uint32_t count);
static bool registerNotefileTemplate(void);
#endif

// Scheduled App One-Time Init
bool pingInit()
{

    // Register the app
    schedAppConfig config = {
        .name = "ping",
        .activationPeriodSecs = 60 * 15,
        .pollPeriodSecs = 15,
        .activateFn = NULL,
        .interruptFn = pingISR,
        .pollFn = pingPoll,
        .responseFn = pingResponse,
        .appContext = NULL,
    };
    appID = schedRegisterApp(&config);
    if (appID < 0) {
        return false;
    }

    // Done
    return true;

}

// Poller
void pingPoll(int appID, int state, void *appContext)
{

    // Unused parameter(s)
    (void)appContext;

    // Switch based upon state
    switch (state) {

    // Application was just activated, so simulate
    // sampling data and adding a Note to the Notefile.
    case STATE_ACTIVATED:

#if SURVEY_MODE

        schedSetState(appID, STATE_DEACTIVATED, "ping: nothing to do");
        break;

#else

        // If the template isn't registered, do so
        if (!templateRegistered) {
            registerNotefileTemplate();
            schedSetCompletionState(appID, STATE_ACTIVATED, STATE_DEACTIVATED);
            APP_PRINTF("ping: template registration request\r\n");
            break;
        }

        // Add a note to the file
        static int notecount = 0;
        addNote(++notecount);
        schedSetCompletionState(appID, STATE_DEACTIVATED, STATE_DEACTIVATED);
        APP_PRINTF("ping: note queued\r\n");
        break;

#endif  // SURVEY_MODE

    // When a button is pressed, send a log message
    // and wait for confirmation response all the
    // way from the notecard. Make sure we do this
    // at the maximum power level because frequently
    // this button is used as a "test button" when
    // walking around to test range.
    case STATE_BUTTON:
        atpMaximizePowerLevel();
        ledIndicateAck(1);
        sendHealthLogMessage(true);
        schedSetCompletionState(appID, STATE_DEACTIVATED, STATE_DEACTIVATED);
        APP_PRINTF("ping: sent health update\r\n");
        break;

    }

}

// Interrupt handler
void pingISR(int appID, uint16_t pins, void *appContext)
{

    // Unused parameter(s)
    (void)appContext;

    // Set the state to button, and immediately schedule
    if ((pins & BUTTON1_Pin) != 0) {
        schedActivateNowFromISR(appID, true, STATE_BUTTON);
        return;
    }

}

// Send a note to the health log, and request a reply just
// as a validation of bidirectional communications continuity.
// Note that this method uses "sensorIgnoreTimeWindow()" which
// is NOT AT ALL a good practice because it can step on other
// devices' communications, however because this message is
// being sent by a button-press there is benefit in an
// immediate request/reply.
bool sendHealthLogMessage(bool immediate)
{

    // Create the new request
    J *req = NoteNewRequest("hub.log");
    if (req == NULL) {
        return false;
    }

    // Create a body for the request
    J *body = JCreateObject();
    if (body == NULL) {
        JDelete(req);
        return false;
    }

    // Format the health message
    char message[80] = {0};
    utilAddressToText(ourAddress, message, sizeof(message));
    if (schedAppName(appID)[0] != '\0') {
        strlcat(message, " (", sizeof(message));
        strlcat(message, schedAppName(appID), sizeof(message));
        strlcat(message, ")", sizeof(message));
    }
    strlcat(message, " says hello", sizeof(message));
    JAddStringToObject(req, "text", message);

    // Notify the gateway that we wish to add RSSI/SNR info to the text
    JAddBoolToObject(req, "radio", true);

    // Add an ID to the request, which will be echo'ed
    // back in the response by the notecard itself.  This
    // helps us to identify the asynchronous response
    // without needing to have an additional state.
    JAddNumberToObject(req, "id", REQUESTID_MANUAL_PING);

    // If immediate send is requested, ignore the
    // time window and just send it now.  Also, set
    // the sync flag so that when it arrives on the
    // gateway it is synced immediately to the notehub.
    if (immediate) {
        sensorIgnoreTimeWindow();
        JAddBoolToObject(req, "sync", true);
    }

    // Send the request with the "true" argument meaning
    // that the notecard's response should be sent
    // all the way back from the gateway to us, rather
    // than discarding the response.
    noteSendToGatewayAsync(req, true);
    return true;

}

// Register the notefile template for our data
#if !SURVEY_MODE
static bool registerNotefileTemplate()
{

    // Create the request
    J *req = NoteNewRequest("note.template");
    if (req == NULL) {
        return false;
    }

    // Create the body
    J *body = JCreateObject();
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
    // substituted with the textified application address.
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

    // Fill-in the body template
    JAddNumberToObject(body, "count", TINT32);
    JAddStringToObject(body, "app", TSTRING(40));

    // Attach the body to the request, and send it to the gateway
    JAddItemToObject(req, "body", body);
    noteSendToGatewayAsync(req, true);
    return true;

}
#endif

// Send the periodic ping
#if !SURVEY_MODE
static void addNote(uint32_t count)
{

    // Create the request
    J *req = NoteNewRequest("note.add");
    if (req == NULL) {
        return;
    }

    // Create the body
    J *body = JCreateObject();
    if (body == NULL) {
        JDelete(req);
        return;
    }

    // Set the target notefile
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

    // Fill-in the body
    JAddNumberToObject(body, "count", count);
    if (schedAppName(appID)[0] != '\0') {
        JAddStringToObject(body, "app", schedAppName(appID));
    }

    // Attach the body to the request, and send it to the gateway
    JAddItemToObject(req, "body", body);
    noteSendToGatewayAsync(req, false);

}
#endif

// Gateway Response handler
void pingResponse(int appID, J *rsp, void *appContext)
{

    // Unused parameter(s)
    (void)appID;
    (void)appContext;

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("ping: gateway returned error: %s\r\n", err);
        return;
    }

    // Flash the LED if this is a response to this specific ping request
    switch (JGetInt(rsp, "id")) {

    case REQUESTID_MANUAL_PING:
        ledIndicateAck(2);
        APP_PRINTF("ping: SUCCESSFUL response\r\n");
        break;

#if !SURVEY_MODE
    case REQUESTID_TEMPLATE:
        templateRegistered = true;
        APP_PRINTF("ping: SUCCESSFUL template registration\r\n");
        break;
#endif

    }

}
