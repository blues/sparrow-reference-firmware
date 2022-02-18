// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "hc-sr04.h"

// 3rd-party Header(s)
#include <note.h>

// ST Header(s)
#include <main.h>  // ST system function declarations
#if (CURRENT_BOARD == BOARD_SPARROW_V1_0)
#include <stm32wl55xx.h>
#elif (CURRENT_BOARD == BOARD_SPARROW_V1_1)
#include <stm32wle5xx.h>
#endif
#include <stm32wlxx_hal_tim.h>

// Sparrow Header(s)
#include <framework.h>

// The filename of the test database.  Note that * is replaced by the
// gateway with the Sparrow node's ID, while the # is a special character
// reserved by the Notecard and Notehub for a Scheduled App ID that is
// appended to the device ID within Events.
#define APPLICATION_NOTEFILE "*#depth.qo"

// Define the parameter(s) related to
// configuring the hardware for the sensor
#define HCSR04_ECHO_LINK_Pin             GPIO_PIN_5
#define HCSR04_ECHO_LINK_Port            GPIOA
#define HCSR04_ECHO_LINK_EXTI_IRQn       EXTI9_5_IRQn
#define HCSR04_ECHO_LINK_IT_PRIORITY     15
#define HCSR04_ECHO_LINK_IT_SUBPRIORITY  0

#define HCSR04_TRIG_LINK_Pin             GPIO_PIN_4
#define HCSR04_TRIG_LINK_Port            GPIOA

#define MSI_FREQUENCY_MHZ                48  // 48Mhz

// Define sensor state
static uint32_t start_time;
static size_t duration;

// Our scheduled app's ID
static int appID = -1;

// Timer functions
static TIM_HandleTypeDef htim17;
static void MX_TIM17_StartUsTimer (void) {
    __HAL_TIM_SET_COUNTER (&htim17, 0);
    __HAL_TIM_ENABLE (&htim17);
}
static uint32_t MX_TIM17_StopUsTimer (void) {
    uint32_t ticks = __HAL_TIM_GET_COUNTER(&htim17);
    __HAL_TIM_DISABLE(&htim17);
    return ticks / MSI_FREQUENCY_MHZ;
}

// Application Activation (on wake)
bool hcsr04Activate(int appID)
{
    APP_PRINTF("hcsr04: Entered application callback function: hcsr04Activate\r\n\tappId: %d\r\n", appID);

    // Success
    return true;
}

// Scheduled App One-Time Init
bool hcsr04Init(void)
{
    APP_PRINTF("hcsr04: Initializing application...\r\n");
    bool result = false;

    // Register the application
    schedAppConfig config = {
        .name = "hc-sr04",
        .activationPeriodSecs = 60 * 5,
        .pollPeriodSecs = 5,
        .activateFn = hcsr04Activate,
        .interruptFn = hcsr04ISR,
        .pollFn = hcsr04Poll,
        .responseFn = hcsr04Response,
    };
    appID = schedRegisterApp(&config);
    if (appID < 0) {
        // Failure
        result = false;
    } else {
        // Success
        result = true;
    }

    // Configure the Echo Interrupt
    GPIO_InitTypeDef init = {
    .Mode = GPIO_MODE_IT_RISING_FALLING,
    .Pull = GPIO_PULLDOWN,
    .Speed = GPIO_SPEED_FREQ_VERY_HIGH,
    .Pin = HCSR04_ECHO_LINK_Pin
    };
    HAL_GPIO_Init(HCSR04_ECHO_LINK_Port, &init);
    HAL_NVIC_SetPriority(HCSR04_ECHO_LINK_EXTI_IRQn, HCSR04_ECHO_LINK_IT_PRIORITY, HCSR04_ECHO_LINK_IT_SUBPRIORITY);
    HAL_NVIC_EnableIRQ(HCSR04_ECHO_LINK_EXTI_IRQn);

    // Configure the Trigger Pin
    init.Mode = GPIO_MODE_OUTPUT_PP;
    init.Pull = GPIO_NOPULL;
    init.Speed = GPIO_SPEED_FREQ_LOW;
    init.Pin = HCSR04_TRIG_LINK_Pin;
    HAL_GPIO_Init(HCSR04_TRIG_LINK_Port, &init);


    return result;
}

// Interrupt handler
void hcsr04ISR(int appID, uint16_t pins)
{
    (void)pins;

    /*
     * This callback function is executed directly from the ISR.
     * Only perform ISR sensitive operations and exit quickly.
     */
    if (!schedIsActive(appID)) {
    } else {
        return;
    }
}

// Poller
void hcsr04Poll(int appID, int state)
{
    APP_PRINTF("hcsr04: Entered application callback function: hcsr04Poll\r\n\tappId: %d\tstate: %s\r\n", appID, schedStateName(state));

    // Switch based upon state
    switch (state) {
    case STATE_ACTIVATED:
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

        // Sync immediately
        JAddBoolToObject(req, "sync", true);

        // Set the target notefile
        JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

        // Fill-in the body
        JAddStringToObject(body, "app", "application template");
        JAddStringToObject(body, "msg", "Hello, World!");

        // Send request to the gateway
        noteSendToGatewayAsync(req, true);

        schedSetState(appID, STATE_DEACTIVATED, "hcsr04: completed");
        break;
    }
    default:
        ;
    }
}

// Gateway Response handler
void hcsr04Response(int appID, J *rsp)
{
    APP_PRINTF("hcsr04: Entered application callback function: hcsr04Response\r\n\tappId: %d\trsp: %s\r\n", appID, JConvertToJSONString(rsp));

    // If this is a response timeout, indicate as such
    if (rsp == NULL) {
        APP_PRINTF("hcsr04: response timeout\r\n");
        return;
    }

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("hcsr04: app error response: %d\r\n", err);
        return;
    }

    APP_PRINTF("hcsr04: Note sent SUCCESSFULLY\r\n");
}
