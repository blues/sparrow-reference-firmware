// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "hcsr04q.h"

/************************
 * The SparkFun Qwiic Ultrasonic Distance Sensor is an upgrade to the popular
 * HC-SR04, which provides a microcontroller to enable I2C communication and
 * transform the duration of the ultrasonic ping into millimeters.
 *
 * In order to ensure the device is compatible with the Sparrow, you will need
 * ensure the following conditions are met:
 *
 * - Leave the HC-SR04 I2C pullups intact
 * - Place a 100uF capacitor on the Qwiic power lines (accessed via `VIO` and
 *  `GND` on the Sparrow)
 *
 * These additional components will ensure the device functions as expected, and
 * will perform well in the low-power environment provided by the Sparrow.
 ************************/

// Standard Library
#include <malloc.h>

// ST Header(s)
#include <main.h>  // ST system function declarations

// Blues Header(s)
#include <framework.h>
#include <note.h>

#define HCSR04Q_I2C_RETRY_COUNT 3
#define HCSR04Q_I2C_TIMEOUT_MS  100
#define HCSR04Q_RANGE_REG       0x01

// States for the local state machine
#define STATE_HCSR04Q_ABORT     0
#define STATE_HCSR04Q_CHECK     1

// Special request IDs
#define REQUESTID_TEMPLATE      19790917

// The dynamic filename of the application specific queue.
// NOTE: The Gateway will replace `*` with the originating node's ID.
#define APPLICATION_NOTEFILE    "*#hcsr04q.qo"

typedef struct applicationContext {
    uint8_t i2cAddr;
    // Application status
    bool templateRegistered;  // Only `true` once we've successfully registered the template
    bool done;
} applicationContext;

// Forwards
static void addRangeNote (applicationContext * ctx, bool immediate);
static const char * hcsr04qStateName (int state);
static inline uint16_t queryHcsr04q (applicationContext * ctx);
static bool registerNotefileTemplate (void);

// Application Activation (on wake)
bool hcsr04qActivate (int appID, void *appContext)
{
    APP_PRINTF("hcsr04q: Entered application callback function: hcsr04qActivate\r\n\tappId: %d\r\n", appID);

    // Load Application Context
    applicationContext *ctx = appContext;

    // Reset run state
    ctx->done = false;

    // Success
    return true;
}

// Scheduled App One-Time Init
bool hcsr04qInit (void)
{
    APP_PRINTF("hcsr04q: Initializing application...\r\n");

    bool result = false;

    // Allocate and initialize application context
    applicationContext *ctx = (applicationContext *)malloc(sizeof(applicationContext));
    ctx->i2cAddr = 0x00;  // 0x00 is the factory I2C address, but it should
                          // be configured before device can be used reliably
    ctx->templateRegistered = false;
    ctx->done = false;

    // Ping the sensor to see if it's there
    MX_I2C2_Init();
    if (!(result = MY_I2C2_Ping(ctx->i2cAddr, HCSR04Q_I2C_TIMEOUT_MS, HCSR04Q_I2C_RETRY_COUNT))) {
        APP_PRINTF("hcsr04q: [ERROR] Sensor hardware unavailable!\r\n");
    }
    MX_I2C2_DeInit();

    // If hardware is ready, then register the application
    if (result) {
        // Register the application
        schedAppConfig config = {
            .name = "hc-sr04-qwiic",
            .activationPeriodSecs = 60 * 100,
            .pollPeriodSecs = 5,
            .activateFn = hcsr04qActivate,
            .interruptFn = hcsr04qISR,
            .pollFn = hcsr04qPoll,
            .responseFn = hcsr04qResponse,
            .appContext = ctx,
        };

        // Registration was successful if the application
        // identifier is greater than or equal to zero
        result = (0 <= schedRegisterApp(&config));
    }

    return result;
}

// Interrupt handler
void hcsr04qISR (int appID, uint16_t pins, void *appContext)
{
    // Unused Parameter(s)
    (void)appContext;

    // Activate application if not already running
	if ((pins & BUTTON1_Pin) && !schedIsActive(appID)) {
        schedActivateNowFromISR(appID, true, STATE_HCSR04Q_CHECK);
    }
}

// Poller
void hcsr04qPoll (int appID, int state, void *appContext)
{
    APP_PRINTF("hcsr04q: Entered application callback function: hcsr04qPoll\r\n\tappId: %d\tstate: %s\r\n", appID, hcsr04qStateName(state));

    // Load Application Context
    applicationContext *ctx = appContext;

    // Switch based upon state
    switch (state) {
    case STATE_ACTIVATED:
        if (!ctx->templateRegistered) {
            registerNotefileTemplate();
            schedSetCompletionState(appID, STATE_HCSR04Q_CHECK, STATE_HCSR04Q_ABORT);
        } else {
            schedSetState(appID, STATE_HCSR04Q_CHECK, "hcsr04q: process diagnostics");
        }
        break;

    case STATE_HCSR04Q_CHECK:
        if (ctx->done) {
            schedSetState(appID, STATE_DEACTIVATED, "hcsr04q: completed successfully");
        } else {
            addRangeNote(ctx, true);
            schedSetCompletionState(appID, STATE_HCSR04Q_CHECK, STATE_HCSR04Q_ABORT);
        }
        break;

    case STATE_HCSR04Q_ABORT:
        schedSetState(appID, STATE_DEACTIVATED, "hcsr04q: aborted due to failure!");
        break;

    default:
        ;
    }
}

// Gateway Response handler
void hcsr04qResponse (int appID, J *rsp, void *appContext)
{
    APP_PRINTF("hcsr04q: Entered application callback function: hcsr04qResponse\r\n\tappId: %d", appID);

    char *json_string = JConvertToJSONString(rsp);
    APP_PRINTF("\trsp: %s\r\n", json_string);
    free(json_string);

    // Load Application Context
    applicationContext *ctx = appContext;

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("hcsr04q: gateway returned error: %s\r\n", err);
        schedSetState(appID, STATE_HCSR04Q_ABORT, "hcsr04q: aborting...");
        return;
    }

    // Identify specific response(s)
    switch (JGetInt(rsp, "id")) {
    case REQUESTID_TEMPLATE:
        ctx->templateRegistered = true;
        APP_PRINTF("hcsr04q: SUCCESSFUL template registration\r\n");
        break;
    default:
        APP_PRINTF("hcsr04q: received unexpected response\r\n");
    }
}

// Send the application data
static void addRangeNote (applicationContext * ctx, bool immediate)
{
    APP_PRINTF("hcsr04q: generating range Note\r\n");

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

    // Create the body
    J *body = JAddObjectToObject(req, "body");
    if (body == NULL) {
        JDelete(req);
        return;
    }

    // Fill-in the body
    JAddNumberToObject(body, "range", (JNUMBER)(int16_t)queryHcsr04q(ctx));

    // Send request to the gateway
    noteSendToGatewayAsync(req, false);
    APP_PRINTF("hcsr04q: note request sent\r\n");
}

static inline const char * hcsr04qStateName (int state)
{
    switch (state) {
    case STATE_HCSR04Q_ABORT:
        return "HCSR04Q_ABORT";
    case STATE_HCSR04Q_CHECK:
        return "HCSR04Q_CHECK";
    default:
    {
        static char undefined_state[20];
        schedStateName(state, undefined_state, sizeof(undefined_state));
        return undefined_state;
    }
    }
}

static inline uint16_t queryHcsr04q (applicationContext * ctx) {
    APP_PRINTF("hcsr04q: querying HC-SR04 via Qwiic connector...\r\n");

    uint16_t result, temp;

    MX_I2C2_Init();
    if (!MY_I2C2_ReadRegister(ctx->i2cAddr, HCSR04Q_RANGE_REG, &temp, sizeof(temp), HCSR04Q_I2C_TIMEOUT_MS)) {
        APP_PRINTF("hcsr04q: [ERROR][I2C] Failed to read from register %d!\r\n", HCSR04Q_RANGE_REG);
        result = 0;
    } else {
        // Update run state
        ctx->done = true;

        // Reconstruct uint16_t from uint8_t[2]
        result = (uint16_t)((temp << 8) & 0xFF00);
        result |= (uint16_t)((temp >> 8) & 0x00FF);

        APP_PRINTF("hcsr04q: range value: %u\r\n", result);
    }
    MX_I2C2_DeInit();

    return result;
}

// Register the notefile template for our data
static bool registerNotefileTemplate (void)
{
    APP_PRINTF("hcsr04q: template registration request\r\n");

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
    JAddNumberToObject(body, "range", TINT16);

    // Send request to the gateway
    noteSendToGatewayAsync(req, true);
    return true;
}
