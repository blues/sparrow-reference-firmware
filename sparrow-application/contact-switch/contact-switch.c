// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "contact-switch.h"

/************************
 * The Adafruit Magnetic Contact Switch sensor.
 * For more information visit: https://www.adafruit.com/product/375
 ************************/

// Blues Header(s)
#include <framework.h>
#include <note.h>

// Comment out the following line for debug program flow
#define NDEBUG

// Define application GPIO confirguration
#define CONTACT_SWITCH_Pin             A1_Pin
#define CONTACT_SWITCH_Port            A1_GPIO_Port
#define CONTACT_SWITCH_EXTI_IRQn       EXTI2_IRQn
#define CONTACT_SWITCH_IT_PRIORITY     15
#define CONTACT_SWITCH_IT_SUB_PRIORITY 15

// The dynamic filename of the application specific queue.
// NOTE: The Gateway will replace `*` with the originating node's ID.
#define APPLICATION_NOTEFILE "*#switch.qo"

// TRUE if we've successfully registered the template
static bool templateRegistered = false;

// States for the local state machine
#define STATE_SWITCH_CHANGE         0

// Special request IDs
#define REQUESTID_SWITCH_CHANGE     1
#define REQUESTID_TEMPLATE          2

// Forwards
static bool addNote(int appID);
static bool registerNotefileTemplate();

// Scheduled App One-Time Init
bool contactSwitchInit()
{

    // Register the app
    schedAppConfig config = {
        .name = "Contact Switch",
        .activationPeriodSecs = 60 * 24,
        .pollPeriodSecs = 15,
        .activateFn = NULL,
        .interruptFn = contactSwitchISR,
        .pollFn = contactSwitchPoll,
        .responseFn = contactSwitchResponse,
        .appContext = NULL,
    };
    if (schedRegisterApp(&config) < 0) {
        return false;
    }

    // Initialize CONTACT switch GPIO
    GPIO_InitTypeDef init = {0};
    init.Mode = GPIO_MODE_IT_RISING_FALLING;
    init.Pull = GPIO_PULLUP;
    init.Speed = GPIO_SPEED_FREQ_LOW;
    init.Pin = CONTACT_SWITCH_Pin;
    HAL_GPIO_Init(CONTACT_SWITCH_Port, &init);
    HAL_NVIC_SetPriority(CONTACT_SWITCH_EXTI_IRQn, CONTACT_SWITCH_IT_PRIORITY, CONTACT_SWITCH_IT_SUB_PRIORITY);
    HAL_NVIC_EnableIRQ(CONTACT_SWITCH_EXTI_IRQn);

    // Done
    return true;

}

// Interrupt handler
void contactSwitchISR(int appID, uint16_t pins, void *appContext)
{

    // Unused parameter(s)
    (void)appContext;

    // Set the state to button, and immediately schedule
    if ((pins & CONTACT_SWITCH_Pin) != 0) {
        schedActivateNowFromISR(appID, true, STATE_SWITCH_CHANGE);
        return;
    }

}

// Poller
void contactSwitchPoll(int appID, int state, void *appContext)
{

    // Unused parameter(s)
    (void)appContext;

    // Switch based upon state
    switch (state) {

    case STATE_ONCE:
        registerNotefileTemplate();
        schedSetCompletionState(appID, STATE_SENDING_REQUEST, STATE_DEACTIVATED);
        APP_PRINTF("Contact Switch: initial template registration request\r\n");
        break;

    // Immediately deactivate - nothing to do
    case STATE_ACTIVATED:
        schedSetState(appID, STATE_DEACTIVATED, "Contact Switch: nothing to do");
        break;

    // When a button is pressed, send a log message
    // and wait for confirmation response all the
    // way from the Notecard. Make sure we do this
    // at the maximum power level because frequently
    // this button is used as a "test button" when
    // walking around to test range.
    case STATE_SWITCH_CHANGE:
        if (!templateRegistered) {
            registerNotefileTemplate();
            schedSetCompletionState(appID, STATE_SWITCH_CHANGE, STATE_DEACTIVATED);
            APP_PRINTF("Contact Switch: retry template registration request\r\n");
            break;
        }
        addNote(appID);
#ifdef NDEBUG
        schedSetCompletionState(appID, STATE_DEACTIVATED, STATE_DEACTIVATED);
#else
        schedSetCompletionState(appID, STATE_SENDING_REQUEST, STATE_DEACTIVATED);
#endif
        APP_PRINTF("Contact Switch: sent switch update\r\n");
        // fallthrough to awaiting response

    case STATE_RECEIVING_RESPONSE:
    case STATE_SENDING_REQUEST:
        break;

    default:
        ;
    }

}

// Gateway Response handler
void contactSwitchResponse(int appID, J *rsp, void *appContext)
{

    // Unused parameter(s)
    (void)appID;
    (void)appContext;

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        ledIndicateAck(4);
        APP_PRINTF("Contact Switch: gateway returned error: %s\r\n", err);
        schedSetState(appID, STATE_DEACTIVATED, NULL);
        return;
    }

    // Flash the LED if this is a response to this specific ping request
    switch (JGetInt(rsp, "id")) {

    case REQUESTID_SWITCH_CHANGE:
        ledIndicateAck(2);
        schedSetState(appID, STATE_DEACTIVATED, "Contact Switch: SUCCESSFUL response");
        break;
    case REQUESTID_TEMPLATE:
        templateRegistered = true;
        APP_PRINTF("Contact Switch: SUCCESSFUL template registration\r\n");
        break;
    }

}

// Send the sensor data
static bool addNote(int appID)
{
    // Measure the sensor values
    char * SwitchStatus;
    bool SwitchOpen = (GPIO_PIN_SET == HAL_GPIO_ReadPin(CONTACT_SWITCH_Port, CONTACT_SWITCH_Pin));
    if(SwitchOpen){
        SwitchStatus = "OPEN";
    } else {
        SwitchStatus = "CLOSED";
    }

    // Create the request
    J *req = NoteNewRequest("note.add");
    if (req == NULL) {
        return false;
    }

    // Add an ID to the request, which will be echo'ed
    // back in the response by the notecard itself.  This
    // helps us to identify the asynchronous response
    // without needing to have an additional state.
    JAddNumberToObject(req, "id", REQUESTID_SWITCH_CHANGE);

    // Create the body
    J *body = JCreateObject();
    if (body == NULL) {
        JDelete(req);
        return false;
    }

    // Set the target notefile
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);
    JAddBoolToObject(req, "sync", true);

    // Fill-in the body
    JAddStringToObject(body, "contactSwitch", SwitchStatus);

    // Format the log message
    char message[80] = {0};
    if (schedAppName(appID)[0] != '\0') {
        strlcat(message, schedAppName(appID), sizeof(message));
    }
    strlcat(message, " is ", sizeof(message));
    strlcat(message, SwitchStatus, sizeof(message));

    APP_PRINTF("%s\r\n", message);

    // Attach the body to the request, and send it to the gateway
    JAddItemToObject(req, "body", body);

    // send to gateway
    sensorIgnoreTimeWindow();
#ifdef NDEBUG
    noteSendToGatewayAsync(req, false);
#else
    noteSendToGatewayAsync(req, true);
#endif
    return true;

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
    JAddStringToObject(body, "contactSwitch", TSTRING(7));

    // Attach the body to the request, and send it to the gateway
    JAddItemToObject(req, "body", body);
    noteSendToGatewayAsync(req, true);
    return true;

}
