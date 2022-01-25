################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../sys/startup_stm32wl55jcix.s 

C_SRCS += \
../sys/syscalls.c \
../sys/sysmem.c 

OBJS += \
./sys/startup_stm32wl55jcix.o \
./sys/syscalls.o \
./sys/sysmem.o 

S_DEPS += \
./sys/startup_stm32wl55jcix.d 

C_DEPS += \
./sys/syscalls.d \
./sys/sysmem.d 


# Each subdirectory must supply rules for building sources it contributes
sys/%.o: ../sys/%.s sys/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"
sys/%.o: ../sys/%.c sys/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32WL55xx -DCORE_CM4 -c -I../../sparrow-lora/Application/ -I../../sparrow-lora/Application/Core/Inc -I../../sparrow-lora/Application/App -I../../sparrow-lora/Application/Sensor -I../../sparrow-lora/Application/Core/Radio -I../../note-c -I../../sparrow-lora/Drivers/STM32WLxx_HAL_Driver/Inc -I../../sparrow-lora/Drivers/CMSIS/Include -I../../sparrow-lora/Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy -I../../sparrow-lora/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver -I../../sparrow-lora/Utilities/lpm/tiny_lpm -I../../sparrow-lora/Utilities/misc -I../../sparrow-lora/Utilities/sequencer -I../../sparrow-lora/Utilities/timer -I../../sparrow-lora/Utilities/trace/adv_trace -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-sys

clean-sys:
	-$(RM) ./sys/startup_stm32wl55jcix.d ./sys/startup_stm32wl55jcix.o ./sys/syscalls.d ./sys/syscalls.o ./sys/sysmem.d ./sys/sysmem.o

.PHONY: clean-sys

