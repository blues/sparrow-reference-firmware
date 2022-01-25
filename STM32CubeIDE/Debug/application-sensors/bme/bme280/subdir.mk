################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/user-defined-sensors/bme/bme280/bme280.c 

OBJS += \
./application-sensors/bme/bme280/bme280.o 

C_DEPS += \
./application-sensors/bme/bme280/bme280.d 


# Each subdirectory must supply rules for building sources it contributes
application-sensors/bme/bme280/bme280.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/user-defined-sensors/bme/bme280/bme280.c application-sensors/bme/bme280/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-application-2d-sensors-2f-bme-2f-bme280

clean-application-2d-sensors-2f-bme-2f-bme280:
	-$(RM) ./application-sensors/bme/bme280/bme280.d ./application-sensors/bme/bme280/bme280.o

.PHONY: clean-application-2d-sensors-2f-bme-2f-bme280

