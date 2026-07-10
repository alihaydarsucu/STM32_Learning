/*
 * FreeRTOS V1.8.7 Kernel - FreeRTOSConfig.h for STM32F103 (Cortex-M3)
 *
 * This config is tailored to the STM32F103RBT6 running at 8 MHz (HSI).
 * SysTick is used as the tick source; portTICK_PERIOD_MS = 1000 / configTICK_RATE_HZ.
 */
#ifndef FREERTOS_CONFIG_H
#define FREERTOS_CONFIG_H

/*-----------------------------------------------------------
 * Application specific definitions.
 *----------------------------------------------------------*/

/* The ARM_CM3 port requires portmacro.h to know the Cortex-M3 specifics. */
#define configUSE_PREEMPTION                      1
#define configSUPPORT_STATIC_ALLOCATION           0
#define configSUPPORT_DYNAMIC_ALLOCATION          1
#define configUSE_IDLE_HOOK                       0
#define configUSE_TICK_HOOK                       0
#define configCPU_CLOCK_HZ                        8000000u
#define configTICK_RATE_HZ                        1000u
#define configMAX_PRIORITIES                      56
#define configMINIMAL_STACK_SIZE                  128u
#define configTOTAL_HEAP_SIZE                     (8 * 1024)
#define configMAX_TASK_NAME_LEN                   16
#define configUSE_16_BIT_TICKS                    0
#define configIDLE_SHOULD_YIELD                   1
#define configUSE_TASK_NOTIFICATIONS              1
#define configUSE_MUTEXES                         1
#define configUSE_RECURSIVE_MUTEXES               1
#define configUSE_COUNTING_SEMAPHORES             1
#define configQUEUE_REGISTRY_SIZE                 8
#define configUSE_QUEUE_SETS                      1
#define configUSE_TIME_SLICING                    1
#define configUSE_NEWLIB_REENTRANT                0
#define configENABLE_BACKWARD_COMPATIBILITY       1
#define configUSE_PORT_OPTIMISED_TASK_SELECTION   0

/* CMSIS-RTOS v2 wrapper: exclude osThreadEnumerate to avoid needing the
   trace facility, and require exactly 56 priorities (already set above). */
#define configUSE_OS2_THREAD_ENUMERATE            0

/* Software timer definitions */
#define configUSE_TIMERS                          1
#define configTIMER_TASK_PRIORITY                 2
#define configTIMER_QUEUE_LENGTH                  10
#define configTIMER_TASK_STACK_DEPTH              128

/* Set the following definitions to 1 to include the API function, or zero
   to exclude it. */
#define INCLUDE_vTaskPrioritySet                  1
#define INCLUDE_uxTaskPriorityGet                 1
#define INCLUDE_vTaskDelete                       1
#define INCLUDE_vTaskSuspend                      1
#define INCLUDE_vTaskDelayUntil                   1
#define INCLUDE_vTaskDelay                        1
#define INCLUDE_xTaskGetSchedulerState            1
#define INCLUDE_xTaskGetCurrentTaskHandle         1
#define INCLUDE_uxTaskGetStackHighWaterMark       1
#define INCLUDE_xTaskGetIdleTaskHandle            1
#define INCLUDE_eTaskGetState                     1
#define INCLUDE_xTimerPendFunctionCall            1
#define INCLUDE_pcTaskGetTaskName                 1
#define INCLUDE_xSemaphoreGetMutexHolder          1

/* Cortex-M3 port specifics */
#define configKERNEL_INTERRUPT_PRIORITY           255u
#define configMAX_SYSCALL_INTERRUPT_PRIORITY      191u
#define configMAX_API_CALL_INTERRUPT_PRIORITY     191u

#define configASSERT(x) if ((x) == 0) { taskDISABLE_INTERRUPTS(); for (;;); }

/* Map Newlib/printf to be safe with the RTOS (avoid blocking calls). */
#ifdef __ICCARM__
#include <stdint.h>
extern void *__dso_handle;
#endif

#endif /* FREERTOS_CONFIG_H */
