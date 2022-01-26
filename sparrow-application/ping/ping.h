
#pragma once

// Standard Libraries
#include <stdbool.h>
#include <stdint.h>

// 3rd-party Libraries
#include <note.h>

bool pingInit(void);
void pingISR(int sensorID, uint16_t pins);
void pingPoll(int sensorID, int state);
void pingResponse(int sensorID, J *rsp);
