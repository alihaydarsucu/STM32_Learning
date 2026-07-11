# 07 – FreeRTOS Multitasking

**CMSIS-RTOS v2** API'si ile FreeRTOS üzerinde çok görevli (multitasking) uygulama.

## Hedef
- FreeRTOS'u HAL üzerinde SMP yapılandırmak (SVC/PendSV/SysTick bağlantısı)
- `osThreadNew` ile birden çok görev oluşturmak
- Paylaşımlı kaynağı (UART) **mutex** ile korumak

## Donanım
| Öğe | Değer |
|-----|-------|
|  LED | PA5 (LD2) |
|  Çıkış | PA2 (USART2_TX) – log |
|  RTOS | FreeRTOS, CMSIS-RTOS v2, heap_4 |

## Ana Kavramlar
- `osKernelInitialize()` / `osKernelStart()`
- `osThreadNew()` ile görev oluşturma ve öncelik
- `osDelay()` ile görev zamanlaması (cooperative yield)
- `osMutexNew()` / `osMutexAcquire()` / `osMutexRelease()` ile kaynak koruması
- Ortak `stm32f1xx_it.c` içinde `#ifdef USE_FREERTOS` ile vPortSVCHandler / xPortPendSVHandler / xPortSysTickHandler yönlendirmesi

## Kod Özeti
```c
void vTaskLED(void *arg) {
  for (;;) { HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin); osDelay(500); }
}
void vTaskLog(void *arg) {
  for (;;) {
    osMutexAcquire(uart_mutex, osWaitForever);
    snprintf(buf, sizeof(buf), "tick %lu\r\n", counter++);
    HAL_UART_Transmit(&huart2, (uint8_t*)buf, strlen(buf), HAL_MAX_DELAY);
    osMutexRelease(uart_mutex);
    osDelay(1000);
  }
}
```

## Çıktı
- **LD2** 2 Hz'de yanıp sönüyor (500 ms toggle)
- Seri terminalde her **1 sn'de** `tick 0`, `tick 1`, … sayaç satırları (UART mutex ile korunuyor)

## Kurulum & Çalıştırma
```bash
make -C 07_FreeRTOS
st-flash write 07_FreeRTOS/build/07_FreeRTOS.bin 0x08000000
screen /dev/ttyACM0 115200
```

## Öğrenilenler
- RTOS zamanlayıcı kesme hattının (SVC/PendSV/SysTick) HAL ile bağlanması
- Görev oluşturma, öncelik ve zamanlama
- Mutex ile paylaşımlı kaynağa eşzamanlı erişimin korunması
- RAM tabanlı bellek yönetimi (`heap_4`)