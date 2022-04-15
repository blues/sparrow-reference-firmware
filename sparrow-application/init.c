// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

// Sparrow Header(s)
#include <framework.h>

// Scheduled App Header(s)
#include "bme/bme.h"
#include "button/button.h"
#include "pir/pir.h"

void schedAppInit (void) {
    // Will not initialize if BME280 is not detected
    bmeInit();

    // Will not initialize if not a Sparrow Reference Sensor Board
    pirInit();

    // Reports node identifier and signal health information on button click
    if (!buttonInit()) {
        APP_PRINTF("ERROR: Failed to initialize button application!\r\n");
    }
}
