#!/bin/sh
[ -d cmake-build-debug ] || mkdir cmake-build-debug
cd cmake-build-debug
cmake -DCMAKE_TOOLCHAIN_FILE=../arm-gcc-toolchain.cmake -DCMAKE_BUILD_TYPE=Debug .. && cmake --build . -- -j 4