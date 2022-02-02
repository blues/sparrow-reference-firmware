
// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// 3rd-party Libraries
#include <note.h>

bool diagActivate(int appID);
bool diagInit(void);
void diagISR(int appID, uint16_t pins);
void diagPoll(int appID, int state);
void diagResponse(int appID, J *rsp);
