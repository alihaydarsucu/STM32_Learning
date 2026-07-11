# STM32F103RB Practices

Bu depo, **STM32 NUCLEO-F103RB** geliştirme kartı ile **STM32F103RBT6** üzerinde yaptığım gömülü sistem öğrenme yolculuğunu belgeler. Her faz tek bir çevresel donanımı (peripheral) pratik bir örnekle ele alır; **HAL kütüphanesi** ve komut satırı aracı (`make` + ST-LINK) kullanılır.

> Projenin kurulumu, paylaşımlı `common/` iskeleti ve `tools/` derleme sistemi ile ilgili **[Derleme & Çalıştırma](docs/README.md)** bölümüne bakın. Her fazın detaylı ders notu `docs/XX_*.md` içindedir.

---

## Fazlar

| # | Proje | Peripheraller | Özet | Durum |
|---|-------|---------------|------|-------|
| [00](docs/00_LED_Blink.md) | 00_LED_Blink | GPIO | LD2'yi 500 ms'de yakıp söndüren ilk "merhaba dünya" | ✅ Tamamlandı |
| [01](docs/01_UART_Control.md) | 01_UART_Control | USART2, GPIO | Terminalden `1`/`0` komutuyla LED kontrolü | ✅ Tamamlandı |
| [02](docs/02_PWM_Output.md) | 02_PWM_Output | TIM2 | PA0'da 100 Hz PWM; duty %20→%50→%90 | ✅ Tamamlandı |
| [03](docs/03_ADC_Read.md) | 03_ADC_Read | ADC1, USART2 | Potansiyometre voltajını okuyup seri porta basma | ✅ Tamamlandı |
| [04](docs/04_EXTI_Interrupt.md) | 04_EXTI_Interrupt | EXTI, GPIO | B1 düğmesiyle kesme üzerinden LED toggle | ✅ Tamamlandı |
| [05](docs/05_I2C_OLED.md) | 05_I2C_OLED | I2C1 | SSD1306 OLED'te metin + sayaç gösterme | ✅ Tamamlandı |
| [06](docs/06_Timer_InputCapture.md) | 06_Timer_InputCapture | TIM2, USART2 | Sinyal periyodunu yakalayıp frekans yazdırma | ✅ Tamamlandı |
| [07](docs/07_FreeRTOS.md) | 07_FreeRTOS | FreeRTOS, USART2 | CMSIS-RTOS v2 ile çok görevli uygulama | ✅ Tamamlandı |

---

## Faz Özetleri

### 00 – LED Blink
GPIO çıkışını yapılandırıp `HAL_GPIO_TogglePin` + `HAL_Delay` ile LD2'yi **1 Hz** yanıp söndürür. Toolchain, derleme ve flash akışını uçtan uca doğrular.

### 01 – UART Control
USART2'yi ST-LINK sanal COM portuyla (`/dev/ttyACM0`, 115200 8N1) açar. Terminalden `1`/`0` gönderince UART üzerinden **"LED: ON/OFF"** döndürerek PA5'i kontrol eder.

### 02 – PWM Output
TIM2 CH1'i PWM modunda çalıştırır (Prescaler=72, Period=999 → **100 Hz**). `__HAL_TIM_SET_COMPARE` ile her saniye duty cycle'ı [20, 50, 90]% arasında değiştirir.

### 03 – ADC Read
ADC1 tek kanalda sürekli dönüşüm modunda potansiyometre voltajını örnekler (12-bit). Seri terminale her 200 ms'de `ADC Raw + Voltage` satırı basar.

### 04 – EXTI Interrupt
PC13'e bağlı B1 düğmesini falling-edge kesme (`GPIO_MODE_IT_FALLING`) olarak kurar. ISR'de `volatile` flag set eder; ana döngüde flag'i okuyup LD2'yi toggle eder.

### 05 – I2C OLED
I2C1 (PB6/PB7, 100 kHz) üzerinden SSD1306 OLED sürer. SSD1306 driver ile framebuffer'a yazıp `SSD1306_Update` ile ekrana aktarır; sayaç her 200 ms artar.

### 06 – Timer Input Capture
TIM2'yi kesmeli giriş yakalamada kullanır (1 MHz tick). İki yükselen kenar arası tick farkından periyot/frekans hesaplayıp seri porta yazar (`period=XXXX f=XXXX Hz`).

### 07 – FreeRTOS Multitasking
FreeRTOS'u HAL üzerinde kurar (CMSIS-RTOS v2). Ayrı görevlerle **LD2 2 Hz** blink ve UART üzerinden **`tick N`** loglarını çalıştırır; UART erişimini **mutex** ile korur.

---

## Donanım & Yazılım

- **Kart:** NUCLEO-F103RB
- **MCU:** STM32F103RBT6 (Cortex-M3, 128 KB Flash, 20 KB RAM)
- **Kütüphane:** STM32F1xx HAL + CMSIS
- **Araç seti:** `arm-none-eabi-gcc` (STM32CubeIDE toolchain'i)
- **Flashlama:** `st-flash` / ST-LINK
- **OS:** Arch Linux

## Notlar

- Sanal COM portu: `/dev/ttyACM0`
- ST-LINK firmware: **V2J46M33**
- Paylaşımlı iskelet: `common/` (startup, HAL it, linker script), `Drivers/` (HAL/CMSIS)
- Ortak derleme yapısı: `tools/build.mk`, `tools/toolchain.mk`; tüm fazlar kök `Makefile` ile derlenir
- Tüm fazları derlemek için: `make` — yalnızca birini derlemek için: `make -C <faz>`