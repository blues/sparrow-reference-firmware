# Target name `user-defined-sensors` is required for import
add_library(user-defined-sensors STATIC
    ${CMAKE_CURRENT_LIST_DIR}/diag/diag.c
)

target_include_directories(user-defined-sensors
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}/diag
)

add_dependencies(user-defined-sensors
    sparrow-runtime
)

target_link_libraries(user-defined-sensors
    PRIVATE sparrow-runtime
)
