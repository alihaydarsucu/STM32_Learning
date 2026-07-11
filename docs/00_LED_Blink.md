# 00 – LED Blink

İlk adım: **GPIO çıkışı** ile dahili LED'i yakıp söndürme.

## Hedef
- STM32F103RB'de bir GPIO pinini çıkış olarak yapılandırmayı öğrenmek
- HAL kütüphanesi ile pin durumunu değiştirmek
- Aracı (toolchain, build, flash) uçtan uca doğrulamak

## Donanım
| Öğe | Değer |
|-----|-------|
|  Pin | PA5 (LD2, NUCLEO dahili LED) |
|  Mod | GPIO Output, Push-Pull (`GPIO_MODE_OUTPUT_PP`) |

## Ana Kavramlar
- GPIO port saatini açma: `__HAL_RCC_GPIOA_CLK_ENABLE()`
- `HAL_GPIO_Init()` ile başlangıç yapılandırması
- `HAL_GPIO_TogglePin()` ile pin tersleme
- `HAL_Delay()` ile zamanlama

## Kod Özeti
```c
HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin);
HAL_Delay(500);
```

## Çıktı
- LD2 **her 500 ms'de** terslenir → **1 Hz** yanıp sönme

## Kurulum & Çalıştırma
```bash
make -C 00_LED_Blink
st-flash write 00_LED_Blink/build/00_LED_Blink.bin 0x08000000
```

## Öğrenilenler
- HAL'de GPIO yapılandırma akışı ve pin takma adları
- Projede ortak `common/` iskeleti + `tools/build.mk` paylaşımlı derleme yapısı
