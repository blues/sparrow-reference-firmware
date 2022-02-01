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
void pirISR(int sensorID, uint16_t pins);
void pirPoll(int sensorID, int state);
void pirResponse(int sensorID, J *rsp);
