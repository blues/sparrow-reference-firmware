// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// 3rd-party Libraries
#include <note.h>

bool pingInit(void);
void pingISR(int appID, uint16_t pins, void *appContext);
void pingPoll(int appID, int state, void *appContext);
void pingResponse(int appID, J *rsp, void *appContext);
