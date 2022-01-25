################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/bme280/bme280.c 

OBJS += \
./Application/Sensor/bme280/bme280.o 

C_DEPS += \
./Application/Sensor/bme280/bme280.d 


# Each subdirectory must supply rules for building sources it contributes
Application/Sensor/bme280/bme280.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/bme280/bme280.c Application/Sensor/bme280/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Application-2f-Sensor-2f-bme280

clean-Application-2f-Sensor-2f-bme280:
	-$(RM) ./Application/Sensor/bme280/bme280.d ./Application/Sensor/bme280/bme280.o

.PHONY: clean-Application-2f-Sensor-2f-bme280

