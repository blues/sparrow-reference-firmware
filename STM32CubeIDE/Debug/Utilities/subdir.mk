################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/Utilities/trace/adv_trace/stm32_adv_trace.c \
C:/Users/rozzie/dev/Utilities/lpm/tiny_lpm/stm32_lpm.c \
C:/Users/rozzie/dev/Utilities/misc/stm32_mem.c \
C:/Users/rozzie/dev/Utilities/sequencer/stm32_seq.c \
C:/Users/rozzie/dev/Utilities/misc/stm32_systime.c \
C:/Users/rozzie/dev/Utilities/timer/stm32_timer.c \
C:/Users/rozzie/dev/Utilities/misc/stm32_tiny_vsnprintf.c 

OBJS += \
./Utilities/stm32_adv_trace.o \
./Utilities/stm32_lpm.o \
./Utilities/stm32_mem.o \
./Utilities/stm32_seq.o \
./Utilities/stm32_systime.o \
./Utilities/stm32_timer.o \
./Utilities/stm32_tiny_vsnprintf.o 

C_DEPS += \
./Utilities/stm32_adv_trace.d \
./Utilities/stm32_lpm.d \
./Utilities/stm32_mem.d \
./Utilities/stm32_seq.d \
./Utilities/stm32_systime.d \
./Utilities/stm32_timer.d \
./Utilities/stm32_tiny_vsnprintf.d 


# Each subdirectory must supply rules for building sources it contributes
Utilities/stm32_adv_trace.o: C:/Users/rozzie/dev/Utilities/trace/adv_trace/stm32_adv_trace.c Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Utilities/stm32_lpm.o: C:/Users/rozzie/dev/Utilities/lpm/tiny_lpm/stm32_lpm.c Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Utilities/stm32_mem.o: C:/Users/rozzie/dev/Utilities/misc/stm32_mem.c Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Utilities/stm32_seq.o: C:/Users/rozzie/dev/Utilities/sequencer/stm32_seq.c Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Utilities/stm32_systime.o: C:/Users/rozzie/dev/Utilities/misc/stm32_systime.c Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Utilities/stm32_timer.o: C:/Users/rozzie/dev/Utilities/timer/stm32_timer.c Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Utilities/stm32_tiny_vsnprintf.o: C:/Users/rozzie/dev/Utilities/misc/stm32_tiny_vsnprintf.c Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../ -I../../Core/Inc -I../../App -I../../Sensor -I../../Core/Radio -I../../../note-c -I../../../Drivers/STM32WLxx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Include -I../../../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../../Middlewares/Third_Party/SubGHz_Phy -I../../../Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../../Utilities/lpm/tiny_lpm -I../../../Utilities/misc -I../../../Utilities/sequencer -I../../../Utilities/timer -I../../../Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Utilities

clean-Utilities:
	-$(RM) ./Utilities/stm32_adv_trace.d ./Utilities/stm32_adv_trace.o ./Utilities/stm32_lpm.d ./Utilities/stm32_lpm.o ./Utilities/stm32_mem.d ./Utilities/stm32_mem.o ./Utilities/stm32_seq.d ./Utilities/stm32_seq.o ./Utilities/stm32_systime.d ./Utilities/stm32_systime.o ./Utilities/stm32_timer.d ./Utilities/stm32_timer.o ./Utilities/stm32_tiny_vsnprintf.d ./Utilities/stm32_tiny_vsnprintf.o

.PHONY: clean-Utilities

