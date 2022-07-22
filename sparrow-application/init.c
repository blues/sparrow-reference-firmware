// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

// Sparrow Header(s)
#include <framework.h>

// Scheduled App Header(s)
#include "bme/bme.h"
#include "contact-switch/contact-switch.h"

void schedAppInit (void) {
    // Will not initialize if BME280 is not detected
    bmeInit();

    // Reports door position on change
    if (!contactSwitchInit()) {
        APP_PRINTF("ERROR: Failed to initialize contact switch application!\r\n");
    }
}
