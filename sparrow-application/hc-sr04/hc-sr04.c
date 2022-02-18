// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "hc-sr04.h"

// Standard Library
#include <limits.h>
#include <stddef.h>
#include <stdint.h>

// 3rd-party Header(s)
#include <note.h>

// ST Header(s)
#include <main.h>  // ST system function declarations

// Sparrow Header(s)
#include <framework.h>

// The filename of the test database.  Note that * is replaced by the
// gateway with the Sparrow node's ID, while the # is a special character
// reserved by the Notecard and Notehub for a Scheduled App ID that is
// appended to the device ID within Events.
#define APPLICATION_NOTEFILE  "*#depth.qo"

// Define the parameter(s) related to
// configuring the hardware for the sensor
#define HCSR04_ECHO_LINK_Pin  GPIO_PIN_5
#define HCSR04_ECHO_LINK_Port GPIOA

#define HCSR04_TRIG_LINK_Pin  GPIO_PIN_4
#define HCSR04_TRIG_LINK_Port GPIOA

// Our scheduled app's ID
static int appID = -1;

// Application Activation (on wake)
bool hcsr04Activate(int appID, void *appContext)
{
    // Unused parameter(s)
    (void)appContext;

    APP_PRINTF("hcsr04: Entered application callback function: hcsr04Activate\r\n\tappId: %d\r\n", appID);

    // Success
    return true;
}

//TODO: Use timer for asynchronous implementation, instead of blocking.
size_t __attribute__((optimize("O0"))) sampleRange (void) {
    size_t result, overflow;

    // Power up the sensor
    HAL_GPIO_WritePin(LED_PAIR_GPIO_Port, LED_PAIR_Pin, LED_PAIR_ON);
    TIMER_IF_DelayMs(400);

    // Request sample
    HAL_GPIO_WritePin(HCSR04_TRIG_LINK_Port, HCSR04_TRIG_LINK_Pin, GPIO_PIN_SET);
    HAL_DelayUs(15);  // Must be held HIGH for at least 10uS
    HAL_GPIO_WritePin(HCSR04_TRIG_LINK_Port, HCSR04_TRIG_LINK_Pin, GPIO_PIN_RESET);

    // Block waiting for pulse
    for (size_t timeout = 0, overflow = 0 ; (overflow > timeout) || (GPIO_PIN_RESET == HAL_GPIO_ReadPin(HCSR04_ECHO_LINK_Port, HCSR04_ECHO_LINK_Pin)) ; ++timeout) {
        overflow = timeout;
    }
    for (result = 0, overflow = 0 ; (overflow > result) || (GPIO_PIN_SET == HAL_GPIO_ReadPin(HCSR04_ECHO_LINK_Port, HCSR04_ECHO_LINK_Pin)) ; ++result) {
        overflow = result;
    }

    // Power down the sensor
    HAL_GPIO_WritePin(LED_PAIR_GPIO_Port, LED_PAIR_Pin, LED_PAIR_OFF);

    return result;
}

// Scheduled App One-Time Init
bool hcsr04Init(void)
{
    APP_PRINTF("hcsr04: Initializing application...\r\n");
    bool result;

    // Register the application
    schedAppConfig config = {
        .name = "hc-sr04",
        .activationPeriodSecs = 60,
        .pollPeriodSecs = 15,
        .activateFn = hcsr04Activate,
        .interruptFn = NULL,
        .pollFn = hcsr04Poll,
        .responseFn = NULL,
    };
    appID = schedRegisterApp(&config);
    if (appID < 0) {
        // Failure
        result = false;
    } else {
        // Success
        result = true;
    }

    // Configure Hardware
    //////////////////////

    // Configure the Echo Pin
    GPIO_InitTypeDef init = {
        .Mode = GPIO_MODE_INPUT,
        .Pull = GPIO_NOPULL,
        .Speed = GPIO_SPEED_FREQ_VERY_HIGH,
        .Pin = HCSR04_ECHO_LINK_Pin
    };
    HAL_GPIO_Init(HCSR04_ECHO_LINK_Port, &init);

    // Configure the Trigger Pin
    init.Mode = GPIO_MODE_OUTPUT_PP;
    init.Pull = GPIO_NOPULL;
    init.Speed = GPIO_SPEED_FREQ_LOW;
    init.Pin = HCSR04_TRIG_LINK_Pin;
    HAL_GPIO_Init(HCSR04_TRIG_LINK_Port, &init);

    return result;
}

// Poller
void hcsr04Poll(int appID, int state, void *appContext)
{
    // Unused parameter(s)
    (void)appContext;

    char state_name[19];
    schedStateName(state, state_name, sizeof(state_name));
    APP_PRINTF("hcsr04: Entered application callback function: hcsr04Poll\r\n\tappId: %d\tstate: %s\r\n", appID, state_name);

    // Switch based upon state
    switch (state) {
    case STATE_ACTIVATED:
    {
        // Sample the sensor
        size_t distance = sampleRange();

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

        // Sync immediately
        JAddBoolToObject(req, "sync", true);

        // Set the target notefile
        JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

        // Fill-in the body
        JAddNumberToObject(body, "raw distance", distance);

        // Send request to the gateway
        noteSendToGatewayAsync(req, false);

        schedSetState(appID, STATE_DEACTIVATED, "hcsr04: completed");
        break;
    }
    default:
        ;
    }
}
