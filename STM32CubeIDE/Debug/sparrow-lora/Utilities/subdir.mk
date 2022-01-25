################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/trace/adv_trace/stm32_adv_trace.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/lpm/tiny_lpm/stm32_lpm.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/misc/stm32_mem.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/sequencer/stm32_seq.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/misc/stm32_systime.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/timer/stm32_timer.c \
C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/misc/stm32_tiny_vsnprintf.c 

OBJS += \
./sparrow-lora/Utilities/stm32_adv_trace.o \
./sparrow-lora/Utilities/stm32_lpm.o \
./sparrow-lora/Utilities/stm32_mem.o \
./sparrow-lora/Utilities/stm32_seq.o \
./sparrow-lora/Utilities/stm32_systime.o \
./sparrow-lora/Utilities/stm32_timer.o \
./sparrow-lora/Utilities/stm32_tiny_vsnprintf.o 

C_DEPS += \
./sparrow-lora/Utilities/stm32_adv_trace.d \
./sparrow-lora/Utilities/stm32_lpm.d \
./sparrow-lora/Utilities/stm32_mem.d \
./sparrow-lora/Utilities/stm32_seq.d \
./sparrow-lora/Utilities/stm32_systime.d \
./sparrow-lora/Utilities/stm32_timer.d \
./sparrow-lora/Utilities/stm32_tiny_vsnprintf.d 


# Each subdirectory must supply rules for building sources it contributes
sparrow-lora/Utilities/stm32_adv_trace.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/trace/adv_trace/stm32_adv_trace.c sparrow-lora/Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
sparrow-lora/Utilities/stm32_lpm.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/lpm/tiny_lpm/stm32_lpm.c sparrow-lora/Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
sparrow-lora/Utilities/stm32_mem.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/misc/stm32_mem.c sparrow-lora/Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
sparrow-lora/Utilities/stm32_seq.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/sequencer/stm32_seq.c sparrow-lora/Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
sparrow-lora/Utilities/stm32_systime.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/misc/stm32_systime.c sparrow-lora/Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
sparrow-lora/Utilities/stm32_timer.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/timer/stm32_timer.c sparrow-lora/Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
sparrow-lora/Utilities/stm32_tiny_vsnprintf.o: C:/Users/rozzie/dev/sparrow-accelerator-sensor-firmware/sparrow-lora/Utilities/misc/stm32_tiny_vsnprintf.c sparrow-lora/Utilities/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-sparrow-2d-lora-2f-Utilities

clean-sparrow-2d-lora-2f-Utilities:
	-$(RM) ./sparrow-lora/Utilities/stm32_adv_trace.d ./sparrow-lora/Utilities/stm32_adv_trace.o ./sparrow-lora/Utilities/stm32_lpm.d ./sparrow-lora/Utilities/stm32_lpm.o ./sparrow-lora/Utilities/stm32_mem.d ./sparrow-lora/Utilities/stm32_mem.o ./sparrow-lora/Utilities/stm32_seq.d ./sparrow-lora/Utilities/stm32_seq.o ./sparrow-lora/Utilities/stm32_systime.d ./sparrow-lora/Utilities/stm32_systime.o ./sparrow-lora/Utilities/stm32_timer.d ./sparrow-lora/Utilities/stm32_timer.o ./sparrow-lora/Utilities/stm32_tiny_vsnprintf.d ./sparrow-lora/Utilities/stm32_tiny_vsnprintf.o

.PHONY: clean-sparrow-2d-lora-2f-Utilities

