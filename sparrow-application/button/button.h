// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// Forward Declaration(s)
typedef struct J J;

bool buttonInit(void);
void buttonISR(int appID, uint16_t pins, void *appContext);
void buttonPoll(int appID, int state, void *appContext);
void buttonResponse(int appID, J *rsp, void *appContext);
