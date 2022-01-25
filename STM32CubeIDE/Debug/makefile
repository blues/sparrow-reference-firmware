################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include sys/subdir.mk
-include sparrow-lora/Utilities/subdir.mk
-include sparrow-lora/Middlewares/SubGHz_Phy/subdir.mk
-include sparrow-lora/Drivers/STM32WLxx_HAL_Driver/subdir.mk
-include sparrow-lora/Application/Gateway/subdir.mk
-include sparrow-lora/Application/Core/subdir.mk
-include sparrow-lora/Application/App/subdir.mk
-include note-c/subdir.mk
-include application-sensors/pir/subdir.mk
-include application-sensors/ping/subdir.mk
-include application-sensors/diag/subdir.mk
-include application-sensors/button/subdir.mk
-include application-sensors/bme/bme280/subdir.mk
-include application-sensors/bme/subdir.mk
-include application-sensors/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \


BUILD_ARTIFACT_NAME := sparrow
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
sparrow.elf \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
sparrow.list \

OBJCOPY_BIN += \
sparrow.bin \


# All Target
all: main-build

# Main-build Target
main-build: sparrow.elf secondary-outputs

# Tool invocations
sparrow.elf: $(OBJS) $(USER_OBJS) C:\Users\rozzie\dev\sparrow-accelerator-sensor-firmware\STM32CubeIDE\STM32WL55JCIX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "sparrow.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m4 -T"C:\Users\rozzie\dev\sparrow-accelerator-sensor-firmware\STM32CubeIDE\STM32WL55JCIX_FLASH.ld" --specs=nosys.specs -Wl,-Map="sparrow.map" -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

sparrow.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "sparrow.list"
	@echo 'Finished building: $@'
	@echo ' '

sparrow.bin: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "sparrow.bin"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) default.size.stdout sparrow.bin sparrow.elf sparrow.list
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST) $(OBJCOPY_BIN)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
