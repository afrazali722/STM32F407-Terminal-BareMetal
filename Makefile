# STM32F407G-DISC1 | bare-metal C | GCC + OpenOCD + GDB, no IDE/HAL.
# Tabs below are important: make requires them for recipe lines.

PREFIX       ?= arm-none-eabi-
CC           := $(PREFIX)gcc
OBJCOPY      := $(PREFIX)objcopy
OBJDUMP      := $(PREFIX)objdump
SIZE         := $(PREFIX)size
GDB          := $(PREFIX)gdb
OPENOCD      ?= openocd

NAME         := stm32f407_blink
BUILD_DIR    := build
ELF          := $(BUILD_DIR)/$(NAME).elf
BIN          := $(BUILD_DIR)/$(NAME).bin
HEX          := $(BUILD_DIR)/$(NAME).hex
MAP          := $(BUILD_DIR)/$(NAME).map
LST          := $(BUILD_DIR)/$(NAME).lst

C_SRC        := src/main.c
ASM_SRC      := src/startup_stm32f407.S
OBJ          := $(BUILD_DIR)/main.o $(BUILD_DIR)/startup_stm32f407.o
DEP          := $(OBJ:.o=.d)

CPU_FLAGS    := -mcpu=cortex-m4 -mthumb -mfloat-abi=soft
COMMON_FLAGS := $(CPU_FLAGS) -ffreestanding -fdata-sections -ffunction-sections \
                -fno-builtin -g3 -O2 -Wall -Wextra -Werror
CFLAGS       := $(COMMON_FLAGS) -std=c11 -MMD -MP -Isrc
ASFLAGS      := $(CPU_FLAGS) -g3 -MMD -MP
LDFLAGS      := $(CPU_FLAGS) -nostdlib -nostartfiles -T linker/STM32F407VG_FLASH.ld \
                -Wl,--gc-sections -Wl,--build-id=none -Wl,-Map=$(MAP)

# ST's Discovery kit includes an onboard ST-LINK; no external debugger needed.
OPENOCD_CFG  ?= -f interface/stlink.cfg -f target/stm32f4x.cfg

.PHONY: all flash debug-server gdb size disasm clean check-tools help

all: $(ELF) $(BIN) $(HEX) size

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/main.o: $(C_SRC) src/stm32f407.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/startup_stm32f407.o: $(ASM_SRC) | $(BUILD_DIR)
	$(CC) $(ASFLAGS) -c $< -o $@

$(ELF): $(OBJ) linker/STM32F407VG_FLASH.ld
	$(CC) $(LDFLAGS) $(OBJ) -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

size: $(ELF)
	$(SIZE) $(ELF)

flash: $(ELF)
	$(OPENOCD) $(OPENOCD_CFG) -c "program {$<} verify reset exit"

debug-server:
	$(OPENOCD) $(OPENOCD_CFG)

gdb: $(ELF)
	$(GDB) -q $(ELF) -x scripts/debug.gdb

disasm: $(ELF)
	$(OBJDUMP) -d -S $(ELF) > $(LST)
	@echo "Disassembly: $(LST)"

check-tools:
	@sh scripts/check-tools.sh

clean:
	rm -rf $(BUILD_DIR)

help:
	@printf '%s\n' 'Commands:' '  make check-tools    Check GCC/GDB/OpenOCD' '  make                Build ELF, BIN, HEX' '  make flash          Flash + verify + reset via onboard ST-LINK' '  make debug-server   Run OpenOCD GDB server on port 3333' '  make gdb            Connect GDB (in a second terminal)' '  make disasm         Generate mixed assembly/source listing' '  make clean          Remove generated build files'

-include $(DEP)
