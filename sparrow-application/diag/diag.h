
// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// 3rd-party Libraries
#include <note.h>

bool diagActivate(int sensorID);
bool diagInit(void);
void diagISR(int sensorID, uint16_t pins);
void diagPoll(int sensorID, int state);
void diagResponse(int sensorID, J *rsp);
