// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// 3rd-party Libraries
#include <note.h>

bool pirInit(void);
void pirISR(int appID, uint16_t pins, void *appContext);
void pirPoll(int appID, int state, void *appContext);
void pirResponse(int appID, J *rsp, void *appContext);
