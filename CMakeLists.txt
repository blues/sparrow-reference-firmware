# Set CMake policy behavior
cmake_minimum_required(VERSION 3.16)

# Use the custom ARM toolchain
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/arm-gcc-toolchain.cmake)

# Basic Project Configuration
project(sparrow_sensor_framework
    VERSION 1.0.0
    LANGUAGES C ASM
)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)  # required for inline asm

# Define executible name
set(EXECUTABLE sparrow)

# Create variables to alias path names
set(SDK ${CMAKE_SOURCE_DIR}/sparrow-lora)
set(NOTE_C ${SDK}/note-c)

# Compile `note-c` seperately
add_library(note-c STATIC
    ${NOTE_C}/n_atof.c
    ${NOTE_C}/n_b64.c
    ${NOTE_C}/n_cjson.c
    ${NOTE_C}/n_cjson_helpers.c
    ${NOTE_C}/n_const.c
    ${NOTE_C}/n_ftoa.c
    ${NOTE_C}/n_helpers.c
    ${NOTE_C}/n_hooks.c
    ${NOTE_C}/n_i2c.c
    ${NOTE_C}/n_md5.c
    ${NOTE_C}/n_printf.c
    ${NOTE_C}/n_request.c
    ${NOTE_C}/n_serial.c
    ${NOTE_C}/n_str.c
    ${NOTE_C}/n_ua.c
)

target_include_directories(note-c
    PUBLIC ${NOTE_C}
)

add_executable(${EXECUTABLE}
    ${SDK}/Application/App/app.c
    ${SDK}/Application/App/appinit.c
    ${SDK}/Application/App/atp.c
    ${SDK}/Application/App/dfu.c
    ${SDK}/Application/App/dfuload.c
    ${SDK}/Application/App/flash.c
    ${SDK}/Application/App/gateway.c
    ${SDK}/Application/App/led.c
    ${SDK}/Application/App/note.c
    ${SDK}/Application/App/post.c
    ${SDK}/Application/App/radioinit.c
    ${SDK}/Application/App/sched.c
    ${SDK}/Application/App/sensor.c
    ${SDK}/Application/App/trace.c
    ${SDK}/Application/App/util.c
    ${SDK}/Application/Core/Radio/radio_board_if.c
    ${SDK}/Application/Core/Src/debug.c
    ${SDK}/Application/Core/Src/main.c
    ${SDK}/Application/Core/Src/stm32_lpm_if.c
    ${SDK}/Application/Core/Src/stm32wlxx_hal_msp.c
    ${SDK}/Application/Core/Src/stm32wlxx_it.c
    ${SDK}/Application/Core/Src/system_stm32wlxx.c
    ${SDK}/Application/Core/Src/timer_if.c
    ${SDK}/Application/Core/Src/usart_if.c
    ${SDK}/Application/Core/Src/util_if.c
    ${SDK}/Application/Gateway/auth.c
    ${SDK}/Application/Sensor/bme280/bme280.c
    ${SDK}/Application/Sensor/bme.c
    ${SDK}/Application/Sensor/button.c
    ${SDK}/Application/Sensor/init.c
    ${SDK}/Application/Sensor/ping.c
    ${SDK}/Application/Sensor/pir.c
    ${SDK}/Application/STM32CubeIDE/Application/Startup/startup_stm32wl55jcix.s
    ${SDK}/Application/STM32CubeIDE/sys/syscalls.c
    ${SDK}/Application/STM32CubeIDE/sys/sysmem.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_adc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_adc_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_comp.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_cortex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_crc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_crc_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_cryp.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_cryp_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_dac.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_dac_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_dma.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_dma_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_exti.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_flash.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_flash_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_gpio.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_gtzc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_hsem.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_i2c.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_i2c_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_i2s.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_ipcc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_irda.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_iwdg.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_lptim.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_pka.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_pwr.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_pwr_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_rcc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_rcc_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_rng.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_rng_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_rtc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_rtc_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_smartcard.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_smartcard_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_smbus.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_spi.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_spi_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_subghz.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_tim.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_tim_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_uart.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_uart_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_usart.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_usart_ex.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_hal_wwdg.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_adc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_comp.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_crc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_dac.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_dma.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_exti.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_gpio.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_i2c.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_lptim.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_lpuart.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_pka.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_pwr.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_rcc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_rng.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_rtc.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_spi.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_tim.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_usart.c
    ${SDK}/Drivers/STM32WLxx_HAL_Driver/Src/stm32wlxx_ll_utils.c
    ${SDK}/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio.c
    ${SDK}/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver/radio_driver.c
    ${SDK}/Utilities/lpm/tiny_lpm/stm32_lpm.c
    ${SDK}/Utilities/misc/stm32_mem.c
    ${SDK}/Utilities/misc/stm32_systime.c
    ${SDK}/Utilities/misc/stm32_tiny_sscanf.c
    ${SDK}/Utilities/misc/stm32_tiny_vsnprintf.c
    ${SDK}/Utilities/sequencer/stm32_seq.c
    ${SDK}/Utilities/timer/stm32_timer.c
    ${SDK}/Utilities/trace/adv_trace/stm32_adv_trace.c
)

target_include_directories(${EXECUTABLE}
    PRIVATE ${SDK}/Application
    PRIVATE ${SDK}/Application/App
    PRIVATE ${SDK}/Application/Core/Inc
    PRIVATE ${SDK}/Application/Core/Radio
    PRIVATE ${SDK}/Application/Sensor
    PRIVATE ${SDK}/Application/Sensor/bme280
    SYSTEM ${SDK}/Drivers/CMSIS/Core/Include
    SYSTEM ${SDK}/Drivers/CMSIS/Device/ST/STM32WLxx/Include
    SYSTEM ${SDK}/Drivers/CMSIS/DSP/Include
    SYSTEM ${SDK}/Drivers/CMSIS/Include
    SYSTEM ${SDK}/Drivers/STM32WLxx_HAL_Driver/Inc
    SYSTEM ${SDK}/Drivers/STM32WLxx_HAL_Driver/Inc/Legacy
    SYSTEM ${SDK}/Middlewares/Third_Party/SubGHz_Phy
    SYSTEM ${SDK}/Middlewares/Third_Party/SubGHz_Phy/Conf
    SYSTEM ${SDK}/Middlewares/Third_Party/SubGHz_Phy/stm32_radio_driver
    SYSTEM ${SDK}/Utilities/lpm/tiny_lpm
    SYSTEM ${SDK}/Utilities/misc
    SYSTEM ${SDK}/Utilities/sequencer
    SYSTEM ${SDK}/Utilities/timer
    SYSTEM ${SDK}/Utilities/trace/adv_trace
)

# Add `note-c` dependency relationship
target_link_libraries(${EXECUTABLE} PRIVATE
    note-c
)

target_compile_definitions(${EXECUTABLE} PRIVATE
    -DSTM32WL55xx
    -DCORE_CM4
)

target_compile_options(${EXECUTABLE} PRIVATE
    -mcpu=cortex-m4
#    -std=gnu11
    -g3
    -c
    -O0
    -ffunction-sections
    -fdata-sections
    -Wall
    -fstack-usage
    -MMD
    -MP
    --specs=nano.specs
    -mfloat-abi=soft
    -mthumb
)

target_link_options(${EXECUTABLE} PRIVATE
    -mcpu=cortex-m4
    -T${SDK}/Application/STM32CubeIDE/STM32WL55JCIX_FLASH.ld
    --specs=nosys.specs
    -Wl,-Map=${PROJECT_NAME}.map
    -Wl,--gc-sections
    -static
    --specs=nano.specs
    -mfloat-abi=soft
    -mthumb
    -Wl,--start-group -lc -lm -Wl,--end-group
    -Wl,--print-memory-usage
)

# Additional ARM processing
add_custom_command(TARGET ${EXECUTABLE}
    POST_BUILD
    # Rename executable
    COMMAND mv ${EXECUTABLE} ${EXECUTABLE}.elf

    # Print executable size
    COMMAND ${CMAKE_SIZE_UTIL} ${EXECUTABLE}.elf

    # Create list file
    COMMAND ${CMAKE_OBJDUMP} -h -S  ${EXECUTABLE}.elf  > ${EXECUTABLE}.list

    # Create hex file
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${EXECUTABLE}.elf ${EXECUTABLE}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary ${EXECUTABLE}.elf ${EXECUTABLE}.bin
)
