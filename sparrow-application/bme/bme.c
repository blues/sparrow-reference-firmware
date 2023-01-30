// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#include "bme.h"

// Standard Header(s)
#include <math.h>

// ST Header(s)
#include <main.h>

// Blues Header(s)
#include <framework.h>
#include <note.h>

// 3rd-party Libraries
#include <bme280/bme280.h>

// Special request IDs
#define REQUESTID_TEMPLATE          1

// The dynamic filename of the application specific queue.
// NOTE: The Gateway will replace `*` with the originating node's ID.
#define APPLICATION_NOTEFILE "*#air.qo"

// TRUE if we've successfully registered the template
static bool templateRegistered = false;

// An instance of an env sample
typedef struct {
    double temperature;
    double pressure;
    double humidity;
} envSample;
static envSample envSamples[5];
static envSample lastBME = {0};

// Which I2C device we are using
extern I2C_HandleTypeDef hi2c2;

// Device address
static uint8_t bme_dev_addr = 0;

// Whether or not the next note should sync
static bool syncNow = false;

// Our scheduled app's ID
static int appID = -1;

// Forwards
static bool bme280_read(struct bme280_dev *dev, struct bme280_data *comp_data);
static void bme280_delay_us(uint32_t period, void *intf_ptr);
static int8_t bme280_i2c_read(uint8_t reg_addr, uint8_t *reg_data, uint32_t len, void *intf_ptr);
static int8_t bme280_i2c_write(uint8_t reg_addr, const uint8_t *reg_data, uint32_t len, void *intf_ptr);
static bool addNote(void);
static bool registerNotefileTemplate(void);
static bool bmeUpdate(void);

// Scheduled App One-Time Init
bool bmeInit()
{

    // Power on the sensor to see if it's here
    GPIO_InitTypeDef init = {0};
    init.Speed = GPIO_SPEED_FREQ_HIGH;
    init.Pin = BME_POWER_Pin;
    init.Mode = GPIO_MODE_OUTPUT_PP;
    init.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(BME_POWER_GPIO_Port, &init);
    HAL_GPIO_WritePin(BME_POWER_GPIO_Port, BME_POWER_Pin, GPIO_PIN_SET);
    MX_I2C2_Init();
    bool success = bmeUpdate();
    MX_I2C2_DeInit();
    HAL_GPIO_WritePin(BME_POWER_GPIO_Port, BME_POWER_Pin, GPIO_PIN_RESET);
    if (success) {
        appSetSKU(SKU_REFERENCE);
    } else {
        return false;
    }

    // Register the app
    schedAppConfig config = {
        .name = "bme",
        .activationPeriodSecs = 60 * 60,
        .pollPeriodSecs = 15,
        .activateFn = NULL,
        .interruptFn = NULL,
        .pollFn = bmePoll,
        .responseFn = bmeResponse,
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
void bmePoll(int appID, int state, void *appContext)
{

    // Unused parameter(s)
    (void)appContext;

    // Disable if this isn't a Sparrow reference board
    if (appSKU() != SKU_REFERENCE) {
        schedDisable(appID);
        return;
    }

    // Switch based upon state
    switch (state) {

    case STATE_ACTIVATED:
        if (!templateRegistered) {
            registerNotefileTemplate();
            schedSetCompletionState(appID, STATE_ACTIVATED, STATE_DEACTIVATED);
            APP_PRINTF("bme: template registration request\r\n");
            break;
        }
        if (!addNote()) {
            schedSetState(appID, STATE_DEACTIVATED, "bme: update failure");
        } else {
            schedSetCompletionState(appID, STATE_DEACTIVATED, STATE_DEACTIVATED);
            APP_PRINTF("bme: note queued\r\n");
        }
        break;

    }

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
    JAddNumberToObject(body, "temperature", TFLOAT16);
    JAddNumberToObject(body, "humidity", TFLOAT16);
    JAddNumberToObject(body, "pressure", TFLOAT32);
    JAddNumberToObject(body, "voltage", TFLOAT32);

    // Attach the body to the request, and send it to the gateway
    JAddItemToObject(req, "body", body);
    noteSendToGatewayAsync(req, true);
    return true;

}

// Gateway Response handler
void bmeResponse(int appID, J *rsp, void *appContext)
{

    // Unused parameter(s)
    (void)appID;
    (void)appContext;

    // See if there's an error
    char *err = JGetString(rsp, "err");
    if (err[0] != '\0') {
        APP_PRINTF("bme: gateway returned error: %s\r\n", err);
        return;
    }

    // Flash the LED if this is a response to this specific ping request
    switch (JGetInt(rsp, "id")) {

    case REQUESTID_TEMPLATE:
        templateRegistered = true;
        APP_PRINTF("bme: SUCCESSFUL template registration\r\n");
        break;
    }

}

// Send the sensor data
static bool addNote()
{

    // Measure the sensor values
    HAL_GPIO_WritePin(BME_POWER_GPIO_Port, BME_POWER_Pin, GPIO_PIN_SET);
    MX_I2C2_Init();
    bool success = bmeUpdate();
    MX_I2C2_DeInit();
    HAL_GPIO_WritePin(BME_POWER_GPIO_Port, BME_POWER_Pin, GPIO_PIN_RESET);
    if (!success) {
        APP_PRINTF("bme: update failed\r\n");
        return false;
    }

    // Create the request
    J *req = NoteNewRequest("note.add");
    if (req == NULL) {
        return false;
    }

    // Create the body
    J *body = JCreateObject();
    if (body == NULL) {
        JDelete(req);
        return false;
    }

    // Set the target notefile
    JAddStringToObject(req, "file", APPLICATION_NOTEFILE);

    // If immediate, sync now
    if (syncNow) {
        syncNow = false;
        JAddBoolToObject(req, "sync", true);
    }

    // Fill-in the body
    JAddNumberToObject(body, "temperature", lastBME.temperature);
    JAddNumberToObject(body, "humidity", lastBME.humidity);
    JAddNumberToObject(body, "pressure", lastBME.pressure);
    APP_PRINTF("bme temperature: %d.%dC humidity:%d.%d%%\r\n",
               (int) lastBME.temperature, (int) (fabs(lastBME.temperature*100)) % 100,
               (int) lastBME.humidity, (int) (fabs(lastBME.humidity*100)) % 100);

    // Add the voltage, just for convenient reference
#ifdef USE_SPARROW
    JAddNumberToObject(body, "voltage", MX_ADC_A0_Voltage());
#endif

    // Attach the body to the request, and send it to the gateway
    JAddItemToObject(req, "body", body);
    noteSendToGatewayAsync(req, false);
    return true;

}

// Update the static temp/humidity/pressure values with the most accurate
// values that we can by averaging several samples.
bool bmeUpdate()
{
    bool success = false;

    // Determine whether it's on primary or secondary address
    struct bme280_dev dev;
    dev.intf = BME280_I2C_INTF;
    dev.read = bme280_i2c_read;
    dev.write = bme280_i2c_write;
    dev.delay_us = bme280_delay_us;
    dev.intf_ptr = &bme_dev_addr;
    bme_dev_addr = BME280_I2C_ADDR_PRIM;
    if (bme280_init(&dev) != BME280_INTF_RET_SUCCESS) {
        return success;
    }

    // Allocate a sample buffer
    lastBME.temperature = lastBME.humidity = lastBME.pressure = 0.0;

    // Ignore the first two readings for settling purposes
    struct bme280_data comp_data;
    bme280_read(&dev, &comp_data);
    bme280_read(&dev, &comp_data);

    // Take a set of measurements, discarding data that is very high or very low.  We
    // do this to get the most accurate sample possible.
    int validSamples = 0;
    int totalRetries = 0;
    int maxRetries = (sizeof(envSamples) / sizeof(envSamples[0]))*2;
    struct bme280_data prev_data = {0};
    int samples = sizeof(envSamples) / sizeof(envSamples[0]);
    for (int i=0; i<samples; i++) {

        // Read the sample, and retry if I2C read failure
        if (!bme280_read(&dev, &comp_data)) {
            if (totalRetries++ < maxRetries) {
                --i;
            }
            continue;
        }

        // If we haven't yet converged, retry
        if (totalRetries < maxRetries && i > 0) {
            double tempPct = fabs((comp_data.temperature-prev_data.temperature)/prev_data.temperature);
            double pressPct = fabs((comp_data.pressure-prev_data.pressure)/prev_data.pressure);
            double humidPct = fabs((comp_data.humidity-prev_data.humidity)/prev_data.humidity);
            bool retry = false;
            if (tempPct >= 0.001) {
                retry = true;
            }
            if (pressPct >= 0.0001) {
                retry = true;
            }
            if (humidPct >= 0.005) {
                retry = true;
            }
            if (retry) {
                totalRetries++;
                i = -1;
                validSamples = 0;
                continue;
            }
        }
        memcpy(&prev_data, &comp_data, sizeof(struct bme280_data));

        // Store the sample
        envSamples[validSamples].temperature = comp_data.temperature;
        envSamples[validSamples].pressure = comp_data.pressure;
        envSamples[validSamples].humidity = comp_data.humidity;
        validSamples++;

    }

    // Average the samples (assuming lastBME is already zero'ed)
    if (validSamples) {
        for (int i=0; i<validSamples; i++) {
            lastBME.temperature += envSamples[i].temperature;
            lastBME.pressure += envSamples[i].pressure;
            lastBME.humidity += envSamples[i].humidity;
        }
        lastBME.temperature /= validSamples;
        lastBME.pressure /= validSamples;
        lastBME.humidity /= validSamples;
        success = true;
    }

    // Put the sensor to sleep, to save power if we're leaving it on
    bme280_set_sensor_mode(BME280_SLEEP_MODE, &dev);

    // Done
    return success;

}

// BME280 sensor read
bool bme280_read(struct bme280_dev *dev, struct bme280_data *comp_data)
{
    int8_t rslt;
    uint8_t settings_sel;

    dev->settings.osr_h = BME280_OVERSAMPLING_1X;
    dev->settings.osr_p = BME280_OVERSAMPLING_16X;
    dev->settings.osr_t = BME280_OVERSAMPLING_2X;
    dev->settings.filter = BME280_FILTER_COEFF_16;
    dev->settings.standby_time = BME280_STANDBY_TIME_62_5_MS;

    settings_sel = BME280_OSR_PRESS_SEL;
    settings_sel |= BME280_OSR_TEMP_SEL;
    settings_sel |= BME280_OSR_HUM_SEL;
    settings_sel |= BME280_STANDBY_SEL;
    settings_sel |= BME280_FILTER_SEL;
    rslt = bme280_set_sensor_settings(settings_sel, dev);
    if (rslt != BME280_INTF_RET_SUCCESS) {
        return false;
    }
    rslt = bme280_set_sensor_mode(BME280_NORMAL_MODE, dev);
    if (rslt != BME280_INTF_RET_SUCCESS) {
        return false;
    }

    // Delay while the sensor completes a measurement
    dev->delay_us(70000, dev->intf_ptr);
    memset(comp_data, 0, sizeof(struct bme280_data));
    rslt = bme280_get_sensor_data(BME280_ALL, comp_data, dev);
    if (rslt != BME280_INTF_RET_SUCCESS) {
        return false;
    }

    // If the data looks bad, don't accept it.  (Humidity does operate
    // at the extremes, but these do not and we've seen these failures
    // concurrently, where temp == -40 and press == 110000 && humid == 100%)
    if (comp_data->temperature == -40           // temperature_min
            || comp_data->pressure == 30000.0       // pressure_min
            || comp_data->pressure == 110000.0) {   // pressure_max
        return false;
    }

    return true;
}

// Delay
void bme280_delay_us(uint32_t period, void *intf_ptr)
{
    // Unused parameter(s)
    (void)intf_ptr;

    HAL_DelayUs(period);
}

// Read from sensor
int8_t bme280_i2c_read(uint8_t reg_addr, uint8_t *reg_data, uint32_t len, void *intf_ptr)
{
    // Unused parameter(s)
    (void)intf_ptr;

    bool success = MY_I2C2_ReadRegister(bme_dev_addr, reg_addr, reg_data, len, 5000);
    return (success ? BME280_INTF_RET_SUCCESS : !BME280_INTF_RET_SUCCESS);
}

// Write to sensor
int8_t bme280_i2c_write(uint8_t reg_addr, const uint8_t *reg_data, uint32_t len, void *intf_ptr)
{
    // Unused parameter(s)
    (void)intf_ptr;

    bool success = MY_I2C2_WriteRegister(bme_dev_addr, reg_addr, (uint8_t *) reg_data, len, 5000);
    return (success ? BME280_INTF_RET_SUCCESS : !BME280_INTF_RET_SUCCESS);
}
