/*
 * Compile Command:
 * gcc register.c -c -D CORE_CM4 -D STM32WL55xx -I sparrow-lora/Application/ -I sparrow-lora/Application/App/ -I sparrow-lora/Application/Sensor/ -I sparrow-lora/Application/Core/Inc/ -I sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include/ -I sparrow-lora/Drivers/CMSIS/Include/ -I sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc/ -I sparrow-lora/note-c/ -I sparrow-lora/Utilities/misc -I sparrow-lora/Utilities/trace/adv_trace/ -I sparrow-lora/Utilities/timer/ -o register.o
 */

#include "sensor.h"
#include "diag.h"

int register_sensors (void) {
    diagInit();
}
