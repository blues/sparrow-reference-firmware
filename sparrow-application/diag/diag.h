
// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// Forward Declaration(s)
typedef struct J J;

bool diagActivate(int appID, void *appContext);
bool diagInit(void);
void diagISR(int appID, uint16_t pins, void *appContext);
void diagPoll(int appID, int state, void *appContext);
void diagResponse(int appID, J *rsp, void *appContext);
