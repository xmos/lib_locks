cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(app_locks_example)

set(APP_HW_TARGET XK-EVK-XU316)

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../../..)

set(APP_COMPILER_FLAGS -O2)

include(${CMAKE_CURRENT_LIST_DIR}/../deps.cmake)

XMOS_REGISTER_APP()
