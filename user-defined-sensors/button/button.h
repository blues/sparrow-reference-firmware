
#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// 3rd-party Libraries
#include <note.h>

bool buttonInit(void);
void buttonISR(int sensorID, uint16_t pins);
void buttonPoll(int sensorID, int state);
void buttonResponse(int sensorID, J *rsp);
