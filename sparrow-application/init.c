// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

// Sparrow Header(s)
#include <framework.h>

// Scheduled App Header(s)
#include "bme/bme.h"
#include "diag/diag.h"
#include "pir/pir.h"

void schedAppInit (void) {
    // Will automatically disable if BME280 is not detected
    if (bmeInit()) {
        APP_PRINTF("ERROR: Failed to initialize BME280 application!\r\n");
    }

    // Will automatically disable if BME application is not detected
    if (pirInit()) {
        APP_PRINTF("ERROR: Failed to initialize PIR application!\r\n");
    }

    // Reports memory usage at timed interval or on button click
    if (diagInit()) {
        APP_PRINTF("ERROR: Failed to initialize diagnostic application!\r\n");
    }
}
