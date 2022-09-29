// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "button.h"

// Blues Header(s)
#include <framework.h>
#include <note.h>

// States for the local state machine
#define STATE_BUTTON                0

// Special request IDs
#define REQUESTID_MANUAL_PING       1

// Our scheduled app's ID
static int appID = -1;

// Forwards
static bool sendHealthLogMessage(bool immediate);

// Scheduled App One-Time Init
bool buttonInit()
{

    // Register the app
    schedAppConfig config = {
        .name = "button",
        .activationPeriodSecs = 60 * 24,
        .pollPeriodSecs = 15,
        .activateFn = NULL,
        .interruptFn = buttonISR,
        .pollFn = buttonPoll,
        .responseFn = buttonResponse,
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
void buttonPoll(int appID, int state, void *appContext)
{

    // Unused parameter(s)
    (void)appContext;

    // Switch based upon state
    switch (state) {

    // Immediately deactivate - nothing to do
    case STATE_ACTIVATED:
        schedSetState(appID, STATE_DEACTIVATED, "button: nothing to do");
        break;

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
        APP_PRINTF("button: sent health update\r\n");
        break;

    }

}

// Interrupt handler
void buttonISR(int appID, uint16_t pins, void *appContext)
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

// Gateway Response handler
void buttonResponse(int appID, J *rsp, void *appContext)
{

    // Unused parameter(s)
    (void)appID;
    (void)appContext;

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("button: gateway returned error: %s\r\n", err);
        return;
    }

    // Flash the LED if this is a response to this specific ping request
    switch (JGetInt(rsp, "id")) {

    case REQUESTID_MANUAL_PING:
        ledIndicateAck(2);
        APP_PRINTF("button: SUCCESSFUL response\r\n");
        break;

    }

}
