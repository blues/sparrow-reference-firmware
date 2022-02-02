// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

// Sparrow Header(s)
#include <framework.h>

// Scheduled App Header(s)
#include "diag/diag.h"

void schedAppInit (void) {
    if (diagInit()) {
        APP_PRINTF("ERROR: Failed to initialize diagnostic application!\r\n");
    }
}
