# Copyright 2022 Blues Inc.  All rights reserved.
# Use of this source code is governed by licenses granted by the
# copyright holder including that found in the LICENSE file.

# Target name `sparrow-application` is required for import
add_library(sparrow-application STATIC
    ${CMAKE_CURRENT_LIST_DIR}/bme/bme.c
    ${CMAKE_CURRENT_LIST_DIR}/bme/bme280/bme280.c
    ${CMAKE_CURRENT_LIST_DIR}/button/button.c
    ${CMAKE_CURRENT_LIST_DIR}/contact-switch/contact-switch.c
    ${CMAKE_CURRENT_LIST_DIR}/diag/diag.c
    ${CMAKE_CURRENT_LIST_DIR}/hcsr04q/hcsr04q.c
    ${CMAKE_CURRENT_LIST_DIR}/ping/ping.c
    ${CMAKE_CURRENT_LIST_DIR}/pir/pir.c
)

target_include_directories(sparrow-application
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/bme
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/button
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/contact-switch
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/diag
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/hcsr04q
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/ping
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/pir
)

add_dependencies(sparrow-application
    sparrow-runtime
)

target_link_libraries(sparrow-application
    PRIVATE sparrow-runtime
)

target_compile_options(sparrow-application
    PRIVATE -Wunused-parameter
)
