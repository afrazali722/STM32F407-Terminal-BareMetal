.syntax unified
.cpu cortex-m4
.thumb

/* Cortex-M exception vectors + 82 STM32F407 peripheral IRQ vectors.
 * The first entry is the initial stack pointer value.
 */
.section .isr_vector, "a", %progbits
.align 2
.global g_pfnVectors
g_pfnVectors:
    .word _estack
    .word Reset_Handler
    .word Default_Handler   /* NMI */
    .word Default_Handler   /* HardFault */
    .word Default_Handler   /* MemManage */
    .word Default_Handler   /* BusFault */
    .word Default_Handler   /* UsageFault */
    .word 0                 /* Reserved */
    .word 0                 /* Reserved */
    .word 0                 /* Reserved */
    .word 0                 /* Reserved */
    .word Default_Handler   /* SVCall */
    .word Default_Handler   /* DebugMonitor */
    .word 0                 /* Reserved */
    .word Default_Handler   /* PendSV */
    .word SysTick_Handler   /* SysTick */
    .rept 82
      .word Default_Handler
    .endr

.section .text.Reset_Handler, "ax", %progbits
.align 2
.global Reset_Handler
.type Reset_Handler, %function
.thumb_func
Reset_Handler:
    /* Initialize RAM .data with startup values from flash. */
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
.Lcopy_data:
    cmp r1, r2
    bcs .Lclear_bss_start
    ldr r3, [r0], #4
    str r3, [r1], #4
    b .Lcopy_data

.Lclear_bss_start:
    /* Initialize RAM .bss to zero. */
    ldr r1, =_sbss
    ldr r2, =_ebss
    movs r3, #0
.Lclear_bss:
    cmp r1, r2
    bcs .Lcall_main
    str r3, [r1], #4
    b .Lclear_bss

.Lcall_main:
    bl main
.Lhang:
    b .Lhang
.size Reset_Handler, . - Reset_Handler

.section .text.Default_Handler, "ax", %progbits
.align 2
.global Default_Handler
.type Default_Handler, %function
.thumb_func
Default_Handler:
    b .
.size Default_Handler, . - Default_Handler
