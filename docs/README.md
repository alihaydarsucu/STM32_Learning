# Docs

STM32F103RB öğrenme yolculuğundaki her fazın derinlemesine ders notları.

## Fark Listesi

| Faz | Ders | Docs |
|-----|------|------|
| 00 | GPIO çıkışı ile LED blink | [00_LED_Blink.md](00_LED_Blink.md) |
| 01 | USART2 ile seri kontrol | [01_UART_Control.md](01_UART_Control.md) |
| 02 | TIM2 PWM üretimi | [02_PWM_Output.md](02_PWM_Output.md) |
| 03 | ADC analog okuma | [03_ADC_Read.md](03_ADC_Read.md) |
| 04 | EXTI harici kesme | [04_EXTI_Interrupt.md](04_EXTI_Interrupt.md) |
| 05 | I2C ile SSD1306 OLED | [05_I2C_OLED.md](05_I2C_OLED.md) |
| 06 | TIM giriş yakalama | [06_Timer_InputCapture.md](06_Timer_InputCapture.md) |
| 07 | FreeRTOS multitasking | [07_FreeRTOS.md](07_FreeRTOS.md) |

Her dosya şunları içerir:
- **Hedef** – fazın amacı
- **Donanım** – kullanılan pinler ve peripheral
- **Ana Kavramlar** – öğretilen yapılar/API'ler
- **Kod Özeti** – temel mantığın kısa kesiti
- **Çıktı** – gözlemlenen sonuç
- **Kurulum & Çalıştırma** – derleme ve flash komutları
- **Öğrenilenler** – çıkarılacak dersler