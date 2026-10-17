#include <stdint.h>
#include "stm32f407.h"

/* Reset clock default on STM32F407: 16 MHz internal HSI oscillator.
 * We deliberately do not switch PLL or clock sources in this demo.
 */
#define HSI_HZ         16000000UL
#define SYSTICK_HZ     1000UL
#define BLINK_MS       500UL

static volatile uint32_t g_millis = 0;

/* Called by exception vector 15, once every millisecond. */
void SysTick_Handler(void)
{
    ++g_millis;
}

static void gpio_init(void)
{
    /* Enable GPIOD clock (RCC AHB1ENR bit 3). */
    RCC_AHB1ENR |= RCC_AHB1ENR_GPIODEN;
    (void)RCC_AHB1ENR;  /* Readback after clock-enable write. */

    /* PD12 -> general purpose output (MODER12 = 01). */
    GPIOD_MODER = (GPIOD_MODER & ~(3UL << (12U * 2U)))
                  | (1UL << (12U * 2U));
    GPIOD_OTYPER &= ~LED_GREEN_PD12;             /* Push-pull. */
    GPIOD_OSPEEDR &= ~(3UL << (12U * 2U));      /* Low speed. */
    GPIOD_PUPDR &= ~(3UL << (12U * 2U));        /* No pull. */
    GPIOD_BSRR = LED_GREEN_PD12 << 16U;         /* Initially OFF. */
}

static void systick_init(void)
{
    SYSTICK_CTRL = 0;
    SYSTICK_LOAD = (HSI_HZ / SYSTICK_HZ) - 1UL; /* 15999 = 1 ms. */
    SYSTICK_VAL = 0;                             /* Clear current counter. */
    SYSTICK_CTRL = SYSTICK_CTRL_CLKSOURCE
                 | SYSTICK_CTRL_TICKINT
                 | SYSTICK_CTRL_ENABLE;
}

static void delay_ms(uint32_t interval_ms)
{
    const uint32_t start = g_millis;
    /* Subtraction is rollover-safe for intervals shorter than 2^31 ms. */
    while ((uint32_t)(g_millis - start) < interval_ms) {
        __asm volatile ("wfi"); /* Sleep until the next 1 ms SysTick. */
    }
}

int main(void)
{
    gpio_init();
    systick_init();

    while (1) {
        GPIOD_BSRR = LED_GREEN_PD12;            /* Set PD12 -> LED ON. */
        delay_ms(BLINK_MS);
        GPIOD_BSRR = LED_GREEN_PD12 << 16U;     /* Reset PD12 -> OFF. */
        delay_ms(BLINK_MS);
    }
}
