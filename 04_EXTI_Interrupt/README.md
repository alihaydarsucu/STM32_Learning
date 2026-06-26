# 04 – EXTI Interrupt

Harici kesme (External Interrupt) yapılandırması: bir butona basıldığında
kesme ile LED durumunu değiştirme.

## Amaç

- GPIO harici kesme yapılandırmasını öğrenmek (`GPIO_MODE_IT_FALLING`)
- `EXTI15_10_IRQHandler` ve `HAL_GPIO_EXTI_Callback` ile kesme işlemek
- NVIC'te kesme önceliğini ve etkinleştirmeyi ayarlamak
- Kesme (ISR) içinde işaretçi (flag) kullanarak ana döngüde çalışmak

## Donanım / Bağlantı

- **Kart:** NUCLEO-F103RB
- **MCU:** STM32F103RBT6
- **LED:** PA5 (Nucleo üzerindeki dahili LD2)
- **Buton:** PC13 (Nucleo üzerindeki dahili B1)

| Pin  | Fonksiyon      | Açıklama            |
|------|----------------|---------------------|
| PA5  | GPIO Out       | LD2 (dahili LED)    |
| PC13 | EXTI13 (fall)  | B1 (dahili buton)   |

## Çalışma Prensibi

`PC13` düşen kenar (falling edge) ile harici kesme kaynağı olarak yapılandırılır
ve `EXTI15_10_IRQn` NVIC'te etkinleştirilir. Butona basılınca kesme tetiklenir;
`HAL_GPIO_EXTI_Callback` içinde global `btn_pressed` işaretçisi `1` yapılır.
Ana `while` döngüsü işaretçiyi görünce `HAL_GPIO_TogglePin` ile LED'i çevirir.

## Beklenen Çıktı

B1 butonuna her basıldığında LD2 durumu ters çevrilir (yanık/sönük).

## Derleme (CLI)

```sh
cd 04_EXTI_Interrupt
make                     # derler (build/ altına)
make flash               # st-flash ya da openocd ile kartı programlar
```

STM32CubeIDE kullanıyorsanız `EXTI_Interrupt.ioc` dosyasını açıp projeyi
oluşturabilirsiniz (`Generate Code`).

## Önemli Noktalar

- GPIO kesme modu `GPIO_MODE_IT_FALLING`, pull-up ile birlikte kullanılır.
- `EXTI15_10_IRQHandler` bu repo'da ortak `common/Src/stm32f1xx_it.c`
  içinde tanımlıdır; ilgili `bt` flag ortak dosyada tutulur.
- ISR içinde `HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_13)` çağrısı callback'i tetikler.
- Ana döngüde `btn_pressed` işaretçisi okunup sıfırlanarak yarış durumu
  (race condition) riski basit tutulur.
