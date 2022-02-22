// Copyright 2022 Blues Inc.  All rights reserved.
// Use of this source code is governed by licenses granted by the
// copyright holder including that found in the LICENSE file.

#pragma once

// Standard Libraries
#include <stdbool.h>

// Forward Declaration(s)
typedef struct J J;

bool bmeInit(void);
void bmePoll(int appID, int state, void *appContext);
void bmeResponse(int appID, J *rsp, void *appContext);
