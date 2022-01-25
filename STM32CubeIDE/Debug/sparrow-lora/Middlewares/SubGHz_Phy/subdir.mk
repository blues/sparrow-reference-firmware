################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio_driver.c 

OBJS += \
./sparrow-lora/Middlewares/SubGHz_Phy/radio.o \
./sparrow-lora/Middlewares/SubGHz_Phy/radio_driver.o 

C_DEPS += \
./sparrow-lora/Middlewares/SubGHz_Phy/radio.d \
./sparrow-lora/Middlewares/SubGHz_Phy/radio_driver.d 


# Each subdirectory must supply rules for building sources it contributes
sparrow-lora/Middlewares/SubGHz_Phy/radio.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio.c sparrow-lora/Middlewares/SubGHz_Phy/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
sparrow-lora/Middlewares/SubGHz_Phy/radio_driver.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio_driver.c sparrow-lora/Middlewares/SubGHz_Phy/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-sparrow-2d-lora-2f-Middlewares-2f-SubGHz_Phy

clean-sparrow-2d-lora-2f-Middlewares-2f-SubGHz_Phy:
	-$(RM) ./sparrow-lora/Middlewares/SubGHz_Phy/radio.d ./sparrow-lora/Middlewares/SubGHz_Phy/radio.o ./sparrow-lora/Middlewares/SubGHz_Phy/radio_driver.d ./sparrow-lora/Middlewares/SubGHz_Phy/radio_driver.o

.PHONY: clean-sparrow-2d-lora-2f-Middlewares-2f-SubGHz_Phy

