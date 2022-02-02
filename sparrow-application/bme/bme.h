// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>

// 3rd-party Libraries
#include <note.h>

bool bmeInit(void);
void bmePoll(int appID, int state);
void bmeResponse(int appID, J *rsp);
