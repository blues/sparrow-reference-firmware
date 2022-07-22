// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

// Sparrow Header(s)
#include <framework.h>

// Scheduled App Header(s)
#include "THAT-button/THAT-button.h"

void schedAppInit (void) {
    // Reports node identifier and signal health information on button click
    if (!thatButtonInit()) {
        APP_PRINTF("ERROR: Failed to initialize THAT button application!\r\n");
    }
}
