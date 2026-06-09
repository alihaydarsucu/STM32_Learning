# 01 – UART Control

Serial haberleşme (USART2) üzerinden terminal komutlarıyla LED kontrolü.

## Amaç

- USART2'yi HAL ile yapılandırmak (115200 baud, 8N1)
- Terminalden alınan karakterlerle LED'i açıp kapatmak
- `HAL_UART_Transmit` / `HAL_UART_Receive` kullanımı

## Donanım / Bağlantı

- **Kart:** NUCLEO-F103RB
- **MCU:** STM32F103RBT6
- **USB-UART:** ST-Link üzerinden sanal COM portu
- **LED:** PA5 (LD2)

| Pin  | Fonksiyon | Açıklama             |
|------|-----------|----------------------|
| PA2  | USART2_TX | Seri veri gönderimi   |
| PA3  | USART2_RX | Seri veri alımı       |
| PA5  | GPIO Out  | LD2 (LCD ile kontrol) |

## Çalışma Prensibi

Ana döngü `HAL_UART_Receive` ile bir karakter bekler:

- `'1'` girilirse `LD2` = `GPIO_PIN_SET` (LED yanar)
- `'0'` girilirse `LD2` = `GPIO_PIN_RESET` (LED söner)
- Başka karakter girilirse kullanıcı bilgilendirilir

Her durumda ekrana gönderilen metin `HAL_UART_Transmit` ile yazılır.

## Beklenen Çıktı

Terminalde şu yazılar görülür:

```
=== 01_UART_Control ===
Send '1' to switch LED ON, '0' to switch LED OFF.
LED: ON
LED: OFF
```

## Derleme (CLI)

```sh
cd 01_UART_Control
make
make flash
```

CubeIDE için `UART_Control.ioc` dosyasını açıp `Generate Code` yapın.

## Önemli Noktalar

- USART2 TX: `GPIO_MODE_AF_PP`, RX: `GPIO_MODE_INPUT`
- Virgül/paket sorunları yaşarsanız `\r\n` satır sonu kullanın.
- Sanal COM portu Linux'ta genellikle `/dev/ttyACM0` altındadır.

```sh
# Kullanıcı arayüzü (örnek)
screen /dev/ttyACM0 115200
```
