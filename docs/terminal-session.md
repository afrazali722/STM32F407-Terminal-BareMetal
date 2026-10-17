# Walkthrough: expected terminal commands

These are **example commands and illustrative output**, not claims that a hardware test was performed for this repository.

## macOS terminal — install

```shell
$ brew install arm-none-eabi-gcc arm-none-eabi-gdb open-ocd
$ make check-tools
[OK]      make
[OK]      arm-none-eabi-gcc
[OK]      arm-none-eabi-objcopy
[OK]      arm-none-eabi-size
[OK]      arm-none-eabi-gdb
[OK]      openocd
```

## Source and build

```shell
$ vim src/main.c
$ make
arm-none-eabi-gcc ... -c src/main.c -o build/main.o
arm-none-eabi-gcc ... -c src/startup_stm32f407.S -o build/startup_stm32f407.o
arm-none-eabi-gcc ... -o build/stm32f407_blink.elf
arm-none-eabi-objcopy -O binary build/stm32f407_blink.elf build/stm32f407_blink.bin
arm-none-eabi-objcopy -O ihex build/stm32f407_blink.elf build/stm32f407_blink.hex
```

## Flash + verify with onboard ST-LINK

```shell
$ make flash
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c 'program {build/stm32f407_blink.elf} verify reset exit'
# OpenOCD identifies the board, programs FLASH, verifies, and resets.
```

## Debug with two terminal windows

**Terminal 1**

```shell
$ make debug-server
# OpenOCD starts its GDB server at localhost:3333
```

**Terminal 2**

```shell
$ make gdb
# Loads build/stm32f407_blink.elf, connects to :3333 and stops at main.
(gdb) next
(gdb) info registers
(gdb) x/4wx 0x40020C00
(gdb) continue
```

## Result

The green **LD4** LED connected to **PD12** should blink 500 ms ON / 500 ms OFF. This is an illustrative result until you actually run the example on your board.
