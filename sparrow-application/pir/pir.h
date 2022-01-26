
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
