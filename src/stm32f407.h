#ifndef STM32F407_MINIMAL_H
#define STM32F407_MINIMAL_H

#include <stdint.h>

/* Minimal register definitions for STM32F407VG. No STM32Cube/HAL/CMSIS needed. */
#define RCC_AHB1ENR     (*(volatile uint32_t *)0x40023830UL)
#define RCC_AHB1ENR_GPIODEN (1UL << 3)

#define GPIOD_MODER     (*(volatile uint32_t *)0x40020C00UL)
#define GPIOD_OTYPER    (*(volatile uint32_t *)0x40020C04UL)
#define GPIOD_OSPEEDR   (*(volatile uint32_t *)0x40020C08UL)
#define GPIOD_PUPDR     (*(volatile uint32_t *)0x40020C0CUL)
#define GPIOD_BSRR      (*(volatile uint32_t *)0x40020C18UL)

#define SYSTICK_CTRL    (*(volatile uint32_t *)0xE000E010UL)
#define SYSTICK_LOAD    (*(volatile uint32_t *)0xE000E014UL)
#define SYSTICK_VAL     (*(volatile uint32_t *)0xE000E018UL)

#define SYSTICK_CTRL_ENABLE    (1UL << 0)
#define SYSTICK_CTRL_TICKINT   (1UL << 1)
#define SYSTICK_CTRL_CLKSOURCE (1UL << 2)

#define LED_GREEN_PD12        (1UL << 12)

#endif /* STM32F407_MINIMAL_H */
