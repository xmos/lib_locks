cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(lib_locks_tests)

add_subdirectory(locks_test_xs2)
add_subdirectory(locks_test_xs3)
