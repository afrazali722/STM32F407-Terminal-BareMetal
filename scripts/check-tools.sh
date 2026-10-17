#!/bin/sh
set -u
missing=0
for name in make arm-none-eabi-gcc arm-none-eabi-objcopy arm-none-eabi-size arm-none-eabi-gdb openocd; do
    if command -v "$name" >/dev/null 2>&1; then
        printf '[OK]      %s\n' "$name"
    else
        printf '[MISSING] %s\n' "$name"
        missing=1
    fi
done
if [ "$missing" -ne 0 ]; then
    echo
    echo 'macOS (Homebrew): brew install arm-none-eabi-gcc arm-none-eabi-gdb open-ocd'
    exit 1
fi
