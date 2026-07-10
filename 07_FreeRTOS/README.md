# 07 – FreeRTOS

Gerçek zamanlı işletim sistemi (FreeRTOS) ve CMSIS-RTOS v2 API ile çok görevli
(thread/multitasking) bir uygulama yazma aşaması.

## Amaç

- FreeRTOS çekirdeğini projeye entegre etmek (CMSIS-RTOS v2)
- `osKernelInitialize`, `osThreadNew` ve `osKernelStart` ile görev oluşturmak
- `osDelay` ile görev zamanlaması, `osMutex` ile paylaşımlı kaynak koruması yapmak
- `SVC/PendSV/SysTick` handler'larının FreeRTOS portuna yönlendirilmesini görmek

## Donanım / Bağlantı

- **Kart:** NUCLEO-F103RB / **MCU:** STM32F103RBT6

| Pin  | Fonksiyon     | Açıklama             |
|------|---------------|----------------------|
| PA2  | USART2_TX     | Log çıktısı (115200)  |
| PA3  | USART2_RX     | (kullanılmıyor)       |
| PA5  | GPIO Out      | LD2 (dahili LED)      |

## Çalışma Prensibi

`osKernelInitialize` sonrası iki görev oluşturulur:

- **LED_Task** – her 500 ms'de LD2'yi çevirir.
- **Log_Task** – her 1000 ms'de artan bir sayacı USART2'ye yazar; yazarken
  `uartMutex` ile seri hattı kilitler (başka görev yazamaz).

`osKernelStart` çağrısı ile FreeRTOS zamanlayıcısı başlar. Çekirdek, ortak
`common/Src/stm32f1xx_it.c` içindeki `SVC/PendSV/SysTick` handler'larını
`USE_FREERTOS` tanımlıyken ilgili FreeRTOS fonksiyonlarına yönlendirir.

## Beklenen Çıktı

LD2 2 Hz'de yanıp söner; seri terminalde her saniye bir sayaç satırı görünür:
```
tick 0
tick 1
tick 2
...
```

## Derleme (CLI)

```sh
cd 07_FreeRTOS
make
make flash
screen /dev/ttyACM0 115200
```

STM32CubeIDE kullanıyorsanız `FreeRTOS.ioc` dosyasını açıp projeyi
oluşturabilirsiniz (`Generate Code`). FreeRTOS çekirdeği `Middlewares/`
altında depoda tutulur; `tools/build.mk` onu otomatik derler.

## Önemli Noktalar

- `FreeRTOSConfig.h` gereklidir; `FreeRTOS.h` onu dahil eder.
- FreeRTOS `SysTick`'i tick kaynağı olarak kullanır; `SysTick_Handler`
  hem `HAL_IncTick` hem `xPortSysTickHandler` çağırır.
- `PendSV`/`SVC` handler'ları FreeRTOS portuna yönlendirilmelidir (burada
  `USE_FREERTOS` ile koşullu yapılır, böylece diğer fazlar etkilenmez).
- Görev yığınları (`osThreadAttr.stack_size`) `configTOTAL_HEAP_SIZE` içinden
  `heap_4.c` ile tahsis edilir (burada 8 KB).
