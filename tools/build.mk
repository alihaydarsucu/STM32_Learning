# build.mk - Shared build rules for a single phase project.
#
# Each phase keeps only phase-specific files in its own Core/:
#   Core/Src/main.c, Core/Src/stm32f1xx_hal_msp.c, Core/Inc/main.h
#
# The device boilerplate (startup, system, syscalls, sysmem, interrupts and
# linker script) lives ONCE in the repo root common/ and is shared by every
# phase, so commits stay small and focused.
#
# Expected variables from the including per-phase Makefile:
#   PROJECT_DIR : absolute path to the phase folder
#   TARGET      : output binary name
#
# Uses:
#   $(REPO_ROOT)/Drivers/       shared HAL + CMSIS
#   $(REPO_ROOT)/common/        shared device boilerplate
#   $(REPO_ROOT)/tools/         toolchain + build rules

-include $(REPO_ROOT)/tools/toolchain.mk

BUILD_DIR := $(PROJECT_DIR)/build

# --- Directories ------------------------------------------------------------
CORE_SRC  := $(PROJECT_DIR)/Core/Src
CORE_INC  := $(PROJECT_DIR)/Core/Inc

COMMON_SRC := $(REPO_ROOT)/common/Src
COMMON_INC := $(REPO_ROOT)/common/Inc
COMMON_STARTUP := $(REPO_ROOT)/common/Startup

DRV_SRC   := $(REPO_ROOT)/Drivers/STM32F1xx_HAL_Driver/Src
DRV_INC   := $(REPO_ROOT)/Drivers/STM32F1xx_HAL_Driver/Inc
CMSIS_DEV := $(REPO_ROOT)/Drivers/CMSIS/Device/ST/STM32F1xx/Include
CMSIS_INC := $(REPO_ROOT)/Drivers/CMSIS/Include
LDSCRIPT  := $(REPO_ROOT)/common/STM32F103RBTX_FLASH.ld

# FreeRTOS kernel (only present in the FreeRTOS phase)
FRT_SRC   := $(PROJECT_DIR)/Middlewares/Third_Party/FreeRTOS/Source

C_INCLUDES := -I$(CORE_INC) -I$(COMMON_INC) -I$(DRV_INC) -I$(CMSIS_DEV) -I$(CMSIS_INC)

# --- Sources ----------------------------------------------------------------
# Phase-specific sources (main.c, stm32f1xx_hal_msp.c) + all shared HAL/device.
C_SOURCES   := $(wildcard $(CORE_SRC)/*.c) \
               $(wildcard $(COMMON_SRC)/*.c) \
               $(wildcard $(DRV_SRC)/*.c)
ASM_SOURCES := $(wildcard $(COMMON_STARTUP)/*.s)

# FreeRTOS phase contributions (only when the Middlewares folder exists)
FRT_C_SOURCES := $(wildcard $(FRT_SRC)/*.c) \
                 $(wildcard $(FRT_SRC)/portable/GCC/ARM_CM3/*.c) \
                 $(wildcard $(FRT_SRC)/portable/MemMang/heap_4.c) \
                 $(wildcard $(FRT_SRC)/CMSIS_RTOS_V2/*.c)
ifneq ($(wildcard $(FRT_SRC)/tasks.c),)
C_SOURCES += $(FRT_C_SOURCES)
C_INCLUDES += -I$(FRT_SRC)/include -I$(FRT_SRC)/portable/GCC/ARM_CM3 \
              -I$(FRT_SRC)/CMSIS_RTOS_V2
PRINTF_EXCLUDE := -fno-builtin-printf
C_DEFS += -DUSE_FREERTOS
C_DEFS += -DCMSIS_device_header=\"stm32f1xx.h\"
C_DEFS += -DUSE_CUSTOM_SYSTICK_HANDLER_IMPLEMENTATION=1
endif

# --- Flags ------------------------------------------------------------------
ASFLAGS := $(MCU) -Wall -g -x assembler-with-cpp
CFLAGS  := $(MCU) -Wall -g -O2 -ffunction-sections -fdata-sections -w $(C_DEFS) $(C_INCLUDES)
LDFLAGS := $(MCU) -T$(LDSCRIPT) -Wl,--gc-sections --specs=nano.specs \
           --specs=nosys.specs -u _printf_float -lm

# --- Objects ----------------------------------------------------------------
OBJS := $(patsubst $(CORE_SRC)/%.c,$(BUILD_DIR)/%.o,$(filter $(CORE_SRC)/%,$(C_SOURCES)))
OBJS += $(patsubst $(COMMON_SRC)/%.c,$(BUILD_DIR)/%.o,$(filter $(COMMON_SRC)/%,$(C_SOURCES)))
OBJS += $(patsubst $(DRV_SRC)/%.c,$(BUILD_DIR)/%.o,$(filter $(DRV_SRC)/%,$(C_SOURCES)))
OBJS += $(patsubst $(FRT_SRC)/%.c,$(BUILD_DIR)/%.o,$(wildcard $(FRT_SRC)/*.c))
OBJS += $(patsubst $(FRT_SRC)/portable/GCC/ARM_CM3/%.c,$(BUILD_DIR)/%.o,$(filter $(FRT_SRC)/portable/GCC/ARM_CM3/%,$(C_SOURCES)))
OBJS += $(patsubst $(FRT_SRC)/portable/MemMang/heap_4.c,$(BUILD_DIR)/heap_4.o,$(filter $(FRT_SRC)/portable/MemMang/heap_4.c,$(C_SOURCES)))
OBJS += $(patsubst $(FRT_SRC)/CMSIS_RTOS_V2/%.c,$(BUILD_DIR)/%.o,$(filter $(FRT_SRC)/CMSIS_RTOS_V2/%,$(C_SOURCES)))
OBJS += $(patsubst $(COMMON_STARTUP)/%.s,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

# --- Rules ------------------------------------------------------------------
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin $(BUILD_DIR)/$(TARGET).hex

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: $(CORE_SRC)/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(COMMON_SRC)/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(DRV_SRC)/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(FRT_SRC)/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(FRT_SRC)/portable/GCC/ARM_CM3/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/heap_4.o: $(FRT_SRC)/portable/MemMang/heap_4.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(FRT_SRC)/CMSIS_RTOS_V2/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(COMMON_STARTUP)/%.s | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O ihex $< $@

# Flash the board. Supports st-flash (ST-LINK) or openocd (ST-LINK via cfg).
FLASH_BIN := $(BUILD_DIR)/$(TARGET).bin
ST_FLASH  := $(shell command -v st-flash 2>/dev/null)
OPENOCD   := $(shell command -v openocd 2>/dev/null)

flash: $(FLASH_BIN)
ifneq ($(strip $(ST_FLASH)),)
	$(ST_FLASH) write $< 0x08000000
else ifneq ($(strip $(OPENOCD)),)
	$(OPENOCD) -f interface/stlink.cfg -f target/stm32f1x.cfg -c "program $< 0x08000000 verify reset exit"
else
	@echo "ERROR: no flasher found. Install st-flash or openocd, or flash $(FLASH_BIN) manually."
	@exit 1
endif

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean flash
