# Troubleshooting

**`arm-none-eabi-gcc: command not found`**

Install the command-line compiler and binaries:

```sh
brew install arm-none-eabi-gcc arm-none-eabi-gdb open-ocd
make check-tools
```

**OpenOCD: `Error: open failed` / `unable to connect to ST-LINK`**

- Connect the Mac to the *ST-LINK USB connector* on the STM32F4 Discovery board, not the target USB OTG connector.
- Use a **data-capable** USB cable; many charging-only cables don't work.
- Close other OpenOCD sessions or IDEs that might be using the debugger.
- Connect directly or through a reliable USB hub and retry.
- Check macOS System Information → USB to confirm the ST-LINK is detected.

**OpenOCD: `Can't find interface/stlink.cfg` or `target/stm32f4x.cfg`**

Check your OpenOCD installation. Homebrew `open-ocd` normally installs these config files; use `openocd -s /path/to/openocd/scripts` if yours uses a nonstandard location. As an alternative, try `-f board/stm32f4discovery.cfg`.

**GDB cannot connect to `localhost:3333`**

Start `make debug-server` in terminal 1, leave it running, then run `make gdb` in terminal 2. GDB won't connect to a server that `make flash` has already exited.

**GDB remote target is halted but won't hit `main`**

Check that you flashed *this* ELF with `make flash`, and that a previous session isn't holding the ST-LINK. Run `monitor reset halt`, set `thbreak main`, then `continue`.

**LED doesn't blink**

- The expected LED is **green LD4 on PD12** (not the always-on red power LED).
- Confirm the MCU is `STM32F407VG` on a compatible STM32F4 Discovery board.
- Verify the terminal reports a successful OpenOCD programming and verification operation.
- A green LED may be hard to notice in bright light. This program uses about 500 ms ON and 500 ms OFF (one cycle per second).
- The delay assumes the default reset clock is **16 MHz HSI**; remove modifications to the clock tree before using this example.

**macOS warns about `arm-none-eabi-gdb`**

Some macOS versions prompt you to authorize newly installed development tools. Use the documented security settings for your system and install tools from trusted sources; do not disable system security globally.
