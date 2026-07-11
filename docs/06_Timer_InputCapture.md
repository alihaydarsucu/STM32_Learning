# 06 – Timer Input Capture

**TIM2 giriş yakalama** ile dış sinyalin periyodunu/frekansını ölçme.

## Hedef
- Timer'ı giriş yakalama modunda kesme ile çalıştırmak
- İki yükselen kenar arasındaki tick sayısından periyodu hesaplamak
- Sonucu USART2'den yazdırmak

## Donanım
| Öğe | Değer |
|-----|-------|
|  Giriş | PA0 (TIM2_CH1), rising edge |
|  Çıkış | PA2 (USART2_TX) |
|  Prescaler | 7 (→ 1 MHz tick) |
|  Period | 0xFFFF |
|  NVIC  | TIM2_IRQn |

## Ana Kavramlar
- `HAL_TIM_IC_Start_IT()` ile kesmeli giriş yakalama
- `HAL_TIM_IC_CaptureCallback()` içinde iki kenar arası fark
- `HAL_TIM_ReadCapturedValue()` ile yakalanan değer
- Frekans hesabı: `freq = ticks_per_sec / period_ticks`
- `__attribute__((weak))` ile zayıf sembol / callback yönlendirmesi

## Kod Özeti
```c
void HAL_TIM_IC_CaptureCallback(TIM_HandleTypeDef* htim) {
  if (htim->Instance == TIM2 && htim->Channel == HAL_TIM_ACTIVE_CHANNEL_1) {
    capture = HAL_TIM_ReadCapturedValue(&htim2, TIM_CHANNEL_1);
    rawperiod = HAL_GetTick() - last_tick;
    ...
  }
}
```

## Çıktı
- PA0'a sinyal uygulandığında her **500 ms'de** seri terminalde:
  `period=XXXX ticks  f=XXXX Hz`

## Kurulum & Çalıştırma
```bash
make -C 06_Timer_InputCapture
st-flash write 06_Timer_InputCapture/build/06_Timer_InputCapture.bin 0x08000000
screen /dev/ttyACM0 115200
```

## Öğrenilenler
- Timer'ı input capture ve kesme ile kullanma
- İki kenar arası ölçümle periyot/frekans hesabı
- Callback zayıf sembol tekniği ve rahat zamanlama okumaları