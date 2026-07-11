# 02 – PWM Output

**TIM2 (Channel 1)** ile PWM sinyali üretme ve duty cycle'ı programatik değiştirme.

## Hedef
- Timer'ı PWM modunda yapılandırmak
- Prescaler/Period ile frekansı hesaplamak
- CCR kaydı ile duty cycle'ı ayarlamak

## Donanım
| Öğe | Değer |
|-----|-------|
|  Çıkış | PA0 (TIM2_CH1) |
|  Prescaler | 71 (→ 1 MHz sayıcı: 8 MHz / (71+1)) |
|  Period    | 999 (→ 100 Hz PWM) |
|  Duty      | CCR ile değiştirilir |

## Ana Kavramlar
- PWM modu: `TIM_OCMODE_PWM1`
- Alternatif fonksiyon GPIO: `GPIO_MODE_AF_PP`
- `HAL_TIM_PWM_Start()` ile çıkışı başlatma
- `__HAL_TIM_SET_COMPARE()` ile duty cycle değiştirme

## Kod Özeti
```c
__HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_1, 200);   // %20
HAL_Delay(1000);
__HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_1, 500);   // %50
HAL_Delay(1000);
__HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_1, 900);   // %90
```

## Çıktı
- PA0'da **100 Hz** PWM sinyali
- Duty cycle her 1 sn'de %20 → %50 → %90 döngüsünde değişir (osiloskop ile doğrulanır)

## Kurulum & Çalıştırma
```bash
make -C 02_PWM_Output
st-flash write 02_PWM_Output/build/02_PWM_Output.bin 0x08000000
```

## Öğrenilenler
- Prescaler + Period ile PWM frekansı hesaplama: `f = timer_clock / ((PSC+1) × (ARR+1))`
- CCR ile görev döngüsü kontrolü
- Osiloskop ile zamanlama sinyali doğrulama
