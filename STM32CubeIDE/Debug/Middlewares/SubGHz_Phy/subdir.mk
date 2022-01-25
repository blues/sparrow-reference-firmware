################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio.c \
C:/Users/rozzie/dev/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio_driver.c 

OBJS += \
./Middlewares/SubGHz_Phy/radio.o \
./Middlewares/SubGHz_Phy/radio_driver.o 

C_DEPS += \
./Middlewares/SubGHz_Phy/radio.d \
./Middlewares/SubGHz_Phy/radio_driver.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/SubGHz_Phy/radio.o: C:/Users/rozzie/dev/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio.c Middlewares/SubGHz_Phy/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Middlewares/SubGHz_Phy/radio_driver.o: C:/Users/rozzie/dev/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio_driver.c Middlewares/SubGHz_Phy/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Middlewares-2f-SubGHz_Phy

clean-Middlewares-2f-SubGHz_Phy:
	-$(RM) ./Middlewares/SubGHz_Phy/radio.d ./Middlewares/SubGHz_Phy/radio.o ./Middlewares/SubGHz_Phy/radio_driver.d ./Middlewares/SubGHz_Phy/radio_driver.o

.PHONY: clean-Middlewares-2f-SubGHz_Phy

