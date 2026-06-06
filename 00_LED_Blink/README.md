# 00 – LED Blink

STM32F103 öğrenme yolculuğunun ilk aşaması: GPIO çıkışı ile LED yakıp söndürme.

## Amaç

- GPIO çıkış yapılandırmasını öğrenmek (`MX_GPIO_Init`)
- `HAL_GPIO_TogglePin` ile dijital çıkışın durumunu değiştirmek
- `HAL_Delay` ile zamanlama yapmak

## Donanım / Bağlantı

- **Kart:** NUCLEO-F103RB
- **MCU:** STM32F103RBT6
- **LED:** PA5 (Nucleo üzerindeki dahili LD2)

| Pin  | Fonksiyon | Açıklama        |
|------|-----------|-----------------|
| PA5  | GPIO Out  | LD2 (dahili LED)|

## Çalışma Prensibi

`LD2` (PA5) çıkış olarak yapılandırılır. Ana döngüde her 500 ms'de bir
`HAL_GPIO_TogglePin` çağrılır. Böylece LED 1 Hz frekansında yanıp söner.

## Beklenen Çıktı

Dahili LD2 LED'i sürekli 500 ms arayla yanıp söner.

## Derleme (CLI)

```sh
cd 00_LED_Blink
make                     # arm-none-eabi-gcc ile derler (build/ altına)
make flash               # st-flash ya da openocd ile kartı programlar
```

STM32CubeIDE kullanıyorsanız `LED_Blink.ioc` dosyasını açıp projeyi
oluşturabilirsiniz (`Generate Code`).

## Önemli Noktalar

- GPIO için önce port saati açılmalıdır: `__HAL_RCC_GPIOA_CLK_ENABLE()`
- Çıkış modu `GPIO_MODE_OUTPUT_PP` (push-pull) seçilir.
- Başlangıç seviyesi `HAL_GPIO_WritePin(..., GPIO_PIN_RESET)` ile söndürülür.
