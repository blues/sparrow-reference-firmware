
#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// 3rd-party Libraries
#include <note.h>

bool bmeInit(void);
void bmePoll(int sensorID, int state);
void bmeResponse(int sensorID, J *rsp);
