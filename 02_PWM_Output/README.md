# 02 – PWM Output

TIM2 (Channel 1) ile analog çıkış benzeri PWM sinyali üretme.

## Amaç

- Zamanlayıcıyı (TIM2) PWM modunda yapılandırmak
- `CCR` (Capture/Compare Register) ile görev döngüsünü değiştirmek
- Sabit frekansta değişken duty cycle üretmek

## Donanım / Bağlantı

- **Kart:** NUCLEO-F103RB
- **MCU:** STM32F103RBT6
- **PWM çıkışı:** PA0 (TIM2_CH1)

| Pin  | Fonksiyon | Açıklama            |
|------|-----------|---------------------|
| PA0  | TIM2_CH1  | PWM çıkışı (PA0)    |

> PWM çıkışını osiloskop ile PA0 pininden izleyebilirsiniz.

## Çalışma Prensibi

TIM2:
- **Prescaler = 71** → 8 MHz / (71+1) = **100 kHz** sayaç tıklaması
- **Period = 999** → (999+1) = 1000 sayım → **100 Hz PWM frekansı**
- Duty cycle, `__HAL_TIM_SET_COMPARE` ile `CCR` (200/500/900) değerine
  ayarlanır: sırasıyla %20, %50, %90.

## Beklenen Çıktı

PA0 pininde 100 Hz'lik PWM sinyali oluşur. Ana döngü her saniyede duty
cycle'ı %20 → %50 → %90 şeklinde değiştirir. Osiloskopta bu değişim net
şekilde görülür.

## Derleme (CLI)

```sh
cd 02_PWM_Output
make
make flash
```

CubeIDE için `PWM_Output.ioc` dosyasını açıp `Generate Code` yapın.

## Önemli Noktalar

- PWM pininin alternatif fonksiyon modunda (`GPIO_MODE_AF_PP`) olması gerekir.
- `HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_1)` ile çıkış başlatılır.
- CCR değeri `Period` değerini aşmamalıdır (0-999 arası).
