cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(tile_lock_test_xs3)

set(APP_HW_TARGET XK-EVK-XU316)

set(APP_COMPILER_FLAGS -O2 -g -DDEBUG_PRINT_ENABLE=1)

include(${CMAKE_CURRENT_LIST_DIR}/../test_deps.cmake)

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../../..)

XMOS_REGISTER_APP()
