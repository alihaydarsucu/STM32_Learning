# 05 – I2C OLED

**I2C donanım protokolü** ile SSSD1306 OLED ekranı sürme.

## Hedef
- I2C1'i standart modda (100 kHz) yapılandırmak
- SSD1306 ekrana adres üzerinden komut/veri göndermek
- RAM framebuffer üzerine çizip ekrana aktarmak

## Donanım
| Öğe | Değer |
|-----|-------|
|  SCL | PB6 (I2C1_SCL) |
|  SDA | PB7 (I2C1_SDA) |
|  Cihaz | SSD1306, adres `0x3C` |
|  Mod | I2C, 7-bit, standart 100 kHz, open-drain (`GPIO_MODE_AF_OD`) |

## Ana Kavramlar
- `HAL_I2C_Master_Transmit()` / `HAL_I2C_Mem_Write()`
- I2C 7-bit adresleme ve open-drain GPIO
- SSD1306 driver ile framebuffer yönetimi (`SSD1306_Clear`, `SSD1306_WriteString`, `SSD1306_Update`)

## Kod Özeti
```c
SSD1306_Clear();
SSD1306_SetCursor(5, 0);
SSD1306_WriteString("STM32F103", &Font_11x18, White);
SSD1306_WriteString("I2C OLED SSD1306", &Font_7x10, White);
snprintf(buf, sizeof(buf), "count: %lu", count++);
SSD1306_WriteString(buf, &Font_7x10, White);
SSD1306_Update();
```

## Çıktı
- OLED'de başlık "STM32F103", alt başlık "I2C OLED SSD1306"
- Her **200 ms'de** artan `count: XXXXX` satırı

## Kurulum & Çalıştırma
```bash
make -C 05_I2C_OLED
st-flash write 05_I2C_OLED/build/05_I2C_OLED.bin 0x08000000
```

## Öğrenilenler
- I2C protokolü: başlatma, adresleme, verify-ACK
- Open-drain hatlar ve pull-up gereksinimi
- Harici sensör/ekran sürücüleriyle iletişim