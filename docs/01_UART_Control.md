# 01 – UART Control

Terminalden komut göndererek LED'i kontrol etme: **Seri haberleşme (USART2)**.

## Hedef
- USART2'yi (ST-LINK sanal COM portu) yapılandırmak
- Terminalden gönderilen karakterleri okuyup LED'i kontrol etmek
- Karakter bazlı basit bir komut protokolü kurmak

## Donanım
| Öğe | Değer |
|-----|-------|
|  USART2_TX | PA2 |
|  USART2_RX | PA3 |
|  LED       | PA5 (LD2) |
|  Baud      | 115200, 8N1 |
|  Port      | `/dev/ttyACM0` (ST-LINK) |

## Ana Kavramlar
- `UART_HandleTypeDef` ile USART2 yapılandırması
- `HAL_UART_Transmit()` / `HAL_UART_Receive()` (blocking)
- Karakter karşılaştırma ile komut çözümleme

## Kod Özeti
```c
HAL_UART_Receive(&huart2, &rx, 1, HAL_MAX_DELAY);
if (rx == '1') { HAL_GPIO_WritePin(LD2_GPIO_Port, LD2_Pin, GPIO_PIN_SET);
                 HAL_UART_Transmit(&huart2, (uint8_t*)"LED: ON\r\n", 9, HAL_MAX_DELAY); }
else if (rx == '0') { ... }
```

## Çıktı
- Terminalde hoş geldin mesajı
- `1` → LED yanar + "LED: ON"
- `0` → LED söner + "LED: OFF"
- Geçersiz karakter → uyarı

## Kurulum & Çalıştırma
```bash
make -C 01_UART_Control
st-flash write 01_UART_Control/build/01_UART_Control.bin 0x08000000
screen /dev/ttyACM0 115200
```

## Öğrenilenler
- UART yapılandırması ve ST-LINK sanal COM portu kullanımı
- Blocking receive ile deterministik akış
- Seri terminal ile etkileşimli donanım kontrolü
