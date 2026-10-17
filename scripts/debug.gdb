# Requires OpenOCD running in a separate terminal (make debug-server).
# `make flash` should be run once before debugging to load the firmware.
set pagination off
set confirm off
target extended-remote localhost:3333
monitor reset halt
thbreak main
continue
# Useful next commands: next, step, info registers, x/16wx 0x40020c00
