
// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>

bool hcsr04Activate(int appID, void *appContext);
bool hcsr04Init(void);
void hcsr04Poll(int appID, int state, void *appContext);
