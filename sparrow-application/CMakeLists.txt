# Target name `user-defined-sensors` is required for import
add_library(user-defined-sensors STATIC
    ${CMAKE_CURRENT_LIST_DIR}/bme/bme.c
    ${CMAKE_CURRENT_LIST_DIR}/bme/bme280/bme280.c
    ${CMAKE_CURRENT_LIST_DIR}/button/button.c
    ${CMAKE_CURRENT_LIST_DIR}/diag/diag.c
    ${CMAKE_CURRENT_LIST_DIR}/ping/ping.c
    ${CMAKE_CURRENT_LIST_DIR}/pir/pir.c
)

target_include_directories(user-defined-sensors
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/bme
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/button
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/diag
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/ping
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/pir
)

add_dependencies(user-defined-sensors
    sparrow-runtime
)

target_link_libraries(user-defined-sensors
    PRIVATE sparrow-runtime
)
