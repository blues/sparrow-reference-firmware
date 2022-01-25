################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Application/Gateway/auth.c 

OBJS += \
./sparrow-lora/Application/Gateway/auth.o 

C_DEPS += \
./sparrow-lora/Application/Gateway/auth.d 


# Each subdirectory must supply rules for building sources it contributes
sparrow-lora/Application/Gateway/auth.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Application/Gateway/auth.c sparrow-lora/Application/Gateway/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-sparrow-2d-lora-2f-Application-2f-Gateway

clean-sparrow-2d-lora-2f-Application-2f-Gateway:
	-$(RM) ./sparrow-lora/Application/Gateway/auth.d ./sparrow-lora/Application/Gateway/auth.o

.PHONY: clean-sparrow-2d-lora-2f-Application-2f-Gateway

