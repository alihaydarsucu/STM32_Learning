# 06 – Timer Input Capture

Bir timer'ın giriş yakalama (Input Capture) özelliğiyle dış bir sinyalin
periyodunu ve frekansını ölçme aşaması.

## Amaç

- Zamanlayıcı (timer) giriş yakalama mantığını öğrenmek
- `HAL_TIM_IC_Start_IT`, `HAL_TIM_ReadCapturedValue` ve
  `HAL_TIM_IC_CaptureCallback` kullanmak
- Yakalanan periyottan frekans hesaplayıp UART üzerinden yazdırmak
- `TIM2_IRQHandler` kesmesini NVIC ile etkinleştirmek

## Donanım / Bağlantı

- **Kart:** NUCLEO-F103RB / **MCU:** STM32F103RBT6
- **Sinyal kaynağı:** Örneğin bir fonksiyon jenaratörü ya da PWM çıkışı (PA0'a bağlanır)

| Pin  | Fonksiyon     | Açıklama                   |
|------|---------------|----------------------------|
| PA0  | TIM2_CH1 (IC) | Ölçülecek sinyal girişi     |
| PA2  | USART2_TX     | Ölçüm sonucu (115200)       |
| PA3  | USART2_RX     | (kullanılmıyor)             |
| PA5  | GPIO Out      | LD2 (dahili LED)            |

## Çalışma Prensibi

`TIM2` 1 MHz'lik bir tick üretecek şekilde (8 MHz / 8) yapılandırılır.
`TIM2_CH1` (PA0) yükselen kenarda giriş yakalama yapar; her kenarda
`HAL_TIM_IC_CaptureCallback` tetiklenir. İki ardışık kenar arasındaki tick
sayısı periyottur. Frekans `f = 1 MHz / periyot(ticks)` olarak hesaplanır ve
her 500 ms'de USART2 üzerinden yazdırılır.

## Beklenen Çıktı

PA0'a uygulanan sinyalin periyodu ve frekansı seri terminalde görünür:
```
period=1000 ticks  f=1000 Hz
```

## Derleme (CLI)

```sh
cd 06_Timer_InputCapture
make
make flash
screen /dev/ttyACM0 115200
```

STM32CubeIDE kullanıyorsanız `Timer_InputCapture.ioc` dosyasını açıp projeyi
oluşturabilirsiniz (`Generate Code`).

## Önemli Noktalar

- F1'de timer giriş yakalama pini giriş (floating) olarak yapılandırılır.
- `TIM2_IRQHandler` bu repo'da ortak `common/Src/stm32f1xx_it.c` içindedir
  ve `htim2` tanımı yoksa zayıf (weak) bir referans olarak davranır.
- 16-bit sayaçla yakalama aralığı 0..65535 tick'tir; ~1 MHz tick ile en düşük
  ölçülebilir frekans ~15 Hz'dir.
- Sayaç taşması (overflow) büyük periyotlarda hesabı bozabilir; bu faz basitlik
  için tek döngü sıfırlamasıyla sınırlıdır.
