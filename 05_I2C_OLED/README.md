# 05 – I2C OLED (SSD1306)

I2C donanımını ve bir harici çevre birimini (SSD1306 OLED ekran) sürmeyi
öğrenme aşaması.

## Amaç

- I2C protokolünü ve 7-bit adresleme mantığını öğrenmek
- `HAL_I2C_Master_Transmit` ve `HAL_I2C_Mem_Write` ile çevre birimine veri göndermek
- Bir RAM framebuffer oluşturup karakter/kaydırma mantığıyla ekranı güncellemek

## Donanım / Bağlantı

- **Kart:** NUCLEO-F103RB / **MCU:** STM32F103RBT6
- **Ekran:** 128x64 SSD1306 OLED (I2C, adres 0x3C)

| Pin  | Fonksiyon     | Açıklama         |
|------|---------------|------------------|
| PB6  | I2C1_SCL      | OLED SCL         |
| PB7  | I2C1_SDA      | OLED SDA         |
| PA5  | GPIO Out      | LD2 (dahili LED) |
| 3.3V | Power         | OLED VCC (VDD)   |
| GND  | Ground        | OLED GND         |

## Çalışma Prensibi

`I2C1` üzerinde 100 kHz standart modda 7-bit adres ile haberleşilir. `ssd1306.c`
driver'ı ekrana gönderilecek 1024 baytlık bir framebuffer tutar. Ana döngüde
`SSD1306_WriteString` ile framebuffer'a karakterler çizilir, ardından
`SSD1306_Update` tüm buffer'ı `HAL_I2C_Mem_Write` ile ekrana taşır.

## Beklenen Çıktı

Ekranda "STM32F103", "I2C OLED SSD1306" ve her 200 ms'de artan bir sayaç görünür.

## Derleme (CLI)

```sh
cd 05_I2C_OLED
make                     # derler (build/ altına)
make flash               # st-flash ya da openocd ile kartı programlar
```

STM32CubeIDE kullanıyorsanız `I2C_OLED.ioc` dosyasını açıp projeyi
oluşturabilirsiniz (`Generate Code`).

## Önemli Noktalar

- I2C pinleri açık-dren (open-drain, `GPIO_MODE_AF_OD`) olmalı; çekme
  dirençleri harici ya da modül üzerinde bulunur.
- Cihaz adresi bayt olarak `0x3C << 1` şeklinde (write biti eklenmiş) verilir.
- `HAL_I2C_MspInit` içinde hem GPIO saatleri hem `I2C1` saatleri açılmalıdır.
- Ekran görüntülenmiyorsa önce adresi (0x3C/0x3D) ve SDA/SCL bağlantısını kontrol edin.
