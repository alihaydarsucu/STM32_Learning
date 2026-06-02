# toolchain.mk - Shared ARM toolchain configuration for all phase projects.
#
# Usage:
#   include ../tools/toolchain.mk
#
# The compiler is resolved in this order:
#   1. $(CROSS_COMPILE) if explicitly provided on the command line
#   2. STM32CubeIDE bundled GNU toolchain (auto-detected)
#   3. arm-none-eabi-gcc on PATH
#
# Example overriding the toolchain from the command line:
#   make CROSS_COMPILE=~/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-

# Absolute path to a phase folder (e.g. 02_PWM_Output). Set by the including Makefile.
PROJECT_DIR  ?= .
REPO_ROOT    ?= $(abspath $(PROJECT_DIR)/..)

# --- Resolve the toolchain prefix ------------------------------------------
ifdef CROSS_COMPILE
TOOLCHAIN_PREFIX := $(CROSS_COMPILE)
else
# STM32CubeIDE bundles its own GNU tools; look for it in common locations.
CUBEIDE_PREFIXES := \
  /opt/ST/STM32CubeIDE*/plugins/*gnu-tools-for-stm32*/tools/bin/arm-none-eabi- \
  /home/*/STM32CubeIDE*/plugins/*gnu-tools-for-stm32*/tools/bin/arm-none-eabi- \
  /home/ali/Programlar/STM32CubeIDE*/plugins/*gnu-tools-for-stm32*/tools/bin/arm-none-eabi-
CUBEIDE_CC := $(firstword $(wildcard $(CUBEIDE_PREFIXES)gcc))
ifneq ($(strip $(CUBEIDE_CC)),)
TOOLCHAIN_PREFIX := $(patsubst %gcc,%,$(CUBEIDE_CC))
else
TOOLCHAIN_PREFIX := arm-none-eabi-
endif
endif

CC      := $(TOOLCHAIN_PREFIX)gcc
OBJCOPY := $(TOOLCHAIN_PREFIX)objcopy
OBJDUMP := $(TOOLCHAIN_PREFIX)objdump
SIZE    := $(TOOLCHAIN_PREFIX)size
GDB     := $(TOOLCHAIN_PREFIX)gdb

# --- Common flags -----------------------------------------------------------
CPU    := -mcpu=cortex-m3 -mthumb
FPU    :=
FLOAT  := -mfloat-abi=soft
MCU    := $(CPU) $(FPU) $(FLOAT)

C_DEFS  := -DUSE_HAL_DRIVER -DSTM32F103xB
