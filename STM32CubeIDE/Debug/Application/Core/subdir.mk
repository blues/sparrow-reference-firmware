################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/debug.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/main.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Radio/radio_board_if.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/stm32_lpm_if.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/stm32wlxx_hal_msp.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/stm32wlxx_it.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/system_stm32wlxx.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/timer_if.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/usart_if.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/util_if.c 

OBJS += \
./Application/Core/debug.o \
./Application/Core/main.o \
./Application/Core/radio_board_if.o \
./Application/Core/stm32_lpm_if.o \
./Application/Core/stm32wlxx_hal_msp.o \
./Application/Core/stm32wlxx_it.o \
./Application/Core/system_stm32wlxx.o \
./Application/Core/timer_if.o \
./Application/Core/usart_if.o \
./Application/Core/util_if.o 

C_DEPS += \
./Application/Core/debug.d \
./Application/Core/main.d \
./Application/Core/radio_board_if.d \
./Application/Core/stm32_lpm_if.d \
./Application/Core/stm32wlxx_hal_msp.d \
./Application/Core/stm32wlxx_it.d \
./Application/Core/system_stm32wlxx.d \
./Application/Core/timer_if.d \
./Application/Core/usart_if.d \
./Application/Core/util_if.d 


# Each subdirectory must supply rules for building sources it contributes
Application/Core/debug.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/debug.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/main.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/main.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/radio_board_if.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Radio/radio_board_if.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/stm32_lpm_if.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/stm32_lpm_if.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/stm32wlxx_hal_msp.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/stm32wlxx_hal_msp.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/stm32wlxx_it.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/stm32wlxx_it.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/system_stm32wlxx.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/system_stm32wlxx.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/timer_if.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/timer_if.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/usart_if.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/usart_if.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Application/Core/util_if.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/Core/Src/util_if.c Application/Core/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Application-2f-Core

clean-Application-2f-Core:
	-$(RM) ./Application/Core/debug.d ./Application/Core/debug.o ./Application/Core/main.d ./Application/Core/main.o ./Application/Core/radio_board_if.d ./Application/Core/radio_board_if.o ./Application/Core/stm32_lpm_if.d ./Application/Core/stm32_lpm_if.o ./Application/Core/stm32wlxx_hal_msp.d ./Application/Core/stm32wlxx_hal_msp.o ./Application/Core/stm32wlxx_it.d ./Application/Core/stm32wlxx_it.o ./Application/Core/system_stm32wlxx.d ./Application/Core/system_stm32wlxx.o ./Application/Core/timer_if.d ./Application/Core/timer_if.o ./Application/Core/usart_if.d ./Application/Core/usart_if.o ./Application/Core/util_if.d ./Application/Core/util_if.o

.PHONY: clean-Application-2f-Core

