# 03 – ADC Read

**ADC1** ile potansiyometre voltajını okuyup seri porta yazdırma.

## Hedef
- ADC'yi tek kanallı, sürekli dönüşüm modunda yapılandırmak
- 12-bit ham değeri voltaja çevirmek
- Formatlı çıktıyı USART2 üzerinden bastırmak

## Donanım
| Öğe | Değer |
|-----|-------|
|  Giriş | PA0 (ADC1_IN0) – analog |
|  Çıkış | PA2 (USART2_TX) |
|  ADC    | 12-bit, sürekli dönüşüm |

## Ana Kavramlar
- `HAL_ADC_Start()` + `HAL_ADC_PollForConversion()`
- `HAL_ADC_GetValue()` ile 12-bit ham örnek
- `HAL_ADCEx_Calibration_Start()` (ADC kalibrasyonu)
- Voltaj hesabı: `raw / 4095 × 3.3V`
- `snprintf()` ile formatlanmış UART çıktısı

## Kod Özeti
```c
HAL_ADC_Start(&hadc1);
HAL_ADC_PollForConversion(&hadc1, 100);
raw = HAL_ADC_GetValue(&hadc1);
voltage = raw / 4095.0f * 3.3f;
snprintf(buf, sizeof(buf), "ADC Raw: %u Voltage: %.2f V\r\n", raw, voltage);
HAL_UART_Transmit(&huart2, (uint8_t*)buf, strlen(buf), HAL_MAX_DELAY);
```

## Çıktı
- Her **200 ms'de** seri terminalde: `ADC Raw: XXXX Voltage: X.XX V`
- Potansiyometre döndürüldükçe değer değişir

## Kurulum & Çalıştırma
```bash
make -C 03_ADC_Read
st-flash write 03_ADC_Read/build/03_ADC_Read.bin 0x08000000
screen /dev/ttyACM0 115200
```

## Öğrenilenler
- ADC'de analog kanal seçimi ve dönüşüm modları
- 12-bit örnek → voltaj dönüşümü
- Analog sinyalleri seri portla izleme
