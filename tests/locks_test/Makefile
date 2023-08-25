# The TARGET variable determines what target system the application is
# compiled for. It either refers to an XN file in the source directories
# or a valid argument for the --target option when compiling.

TARGET ?= XCORE-AI-EXPLORER
#TARGET = SLICEKIT-L16

# The APP_NAME variable determines the name of the final .xe file. It should
# not include the .xe postfix. If left blank the name will default to
# the project name

APP_NAME = $(TARGET)

# The flags passed to xcc when building the application
# You can also set the following to override flags for a particular language:
#
#    XCC_XC_FLAGS, XCC_C_FLAGS, XCC_ASM_FLAGS, XCC_CPP_FLAGS
#
# If the variable XCC_MAP_FLAGS is set it overrides the flags passed to
# xcc for the final link (mapping) stage.

GEN_XCC_FLAGS = -O2 -g -DDEBUG_PRINT_ENABLE=1

XCC_FLAGS_HW = $(GEN_XCC_FLAGS) -DUSE_HW_LOCK=1
XCC_FLAGS_SW = $(GEN_XCC_FLAGS) -DUSE_HW_LOCK=0


# The USED_MODULES variable lists other module used by the application.

USED_MODULES = lib_locks

#=============================================================================
# The following part of the Makefile includes the common build infrastructure
# for compiling XMOS applications. You should not need to edit below here.

XMOS_MAKE_PATH ?= ../..
include $(XMOS_MAKE_PATH)/xcommon/module_xcommon/build/Makefile.common
