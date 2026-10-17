# Board and wiring notes

Board: [STM32F4DISCOVERY / STM32F407G-DISC1 (STMicroelectronics)](https://www.st.com/en/evaluation-tools/stm32f4discovery.html)

- MCU: STM32F407VGT6 (Arm Cortex-M4F).
- Flash: 1 MiB; SRAM: 192 KiB plus 64 KiB CCM (not used here).
- Program/debug interface: onboard ST-LINK/V2-A on newer revisions; older boards may use onboard ST-LINK/V2. **No extra ST-LINK dongle is needed.**
- Power/programming: use the *ST-LINK USB connector* near the integrated ST-LINK area of the board.
- Example output: green **LD4 / PD12**; other user LEDs are orange LD3 / PD13, red LD5 / PD14, blue LD6 / PD15.
- Source code uses direct registers only; no STM32CubeIDE, HAL, or CMSIS pack is required.
- Clock assumption: internal 16 MHz HSI immediately after a standard reset.

The repository's animated visuals are **illustrative demonstrations**. Refer to ST's original board photography and documentation for precise PCB revisions, component locations, and electrical specifications. No hardware execution or physical LED recording is claimed.
