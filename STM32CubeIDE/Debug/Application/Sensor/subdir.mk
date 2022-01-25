################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/bme.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/button.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/init.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/ping.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/pir.c 

OBJS += \
./Application/Sensor/bme.o \
./Application/Sensor/button.o \
./Application/Sensor/init.o \
./Application/Sensor/ping.o \
./Application/Sensor/pir.o 

C_DEPS += \
./Application/Sensor/bme.d \
./Application/Sensor/button.d \
./Application/Sensor/init.d \
./Application/Sensor/ping.d \
./Application/Sensor/pir.d 


# Each subdirectory must supply rules for building sources it contributes
Application/Sensor/bme.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/bme.c Application/Sensor/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Sensor/button.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/button.c Application/Sensor/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Sensor/init.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/init.c Application/Sensor/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Sensor/ping.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/ping.c Application/Sensor/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Sensor/pir.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Sensor/pir.c Application/Sensor/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Application-2f-Sensor

clean-Application-2f-Sensor:
	-$(RM) ./Application/Sensor/bme.d ./Application/Sensor/bme.o ./Application/Sensor/button.d ./Application/Sensor/button.o ./Application/Sensor/init.d ./Application/Sensor/init.o ./Application/Sensor/ping.d ./Application/Sensor/ping.o ./Application/Sensor/pir.d ./Application/Sensor/pir.o

.PHONY: clean-Application-2f-Sensor

