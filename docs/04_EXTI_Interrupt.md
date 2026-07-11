# 04 – EXTI Interrupt

**Harici kesme (EXTI)** ile düğmeye basınca LED'i toggle etme.

## Hedef
- GPIO'yu kesme modunda yapılandırmak
- NVIC'te kesmeyi etkinleştirmek
- ISR'de flag set edip ana döngüde işlemek (ISR-Main ayrımı)

## Donanım
| Öğe | Değer |
|-----|-------|
|  Giriş | PC13 (EXTI13, B1 düğmesi) – falling edge, pull-up |
|  Çıkış | PA5 (LD2) |
|  NVIC  | EXTI15_10_IRQn |

## Ana Kavramlar
- GPIO kesme modu: `GPIO_MODE_IT_FALLING`
- NVIC öncelik ve etkinleştirme: `HAL_NVIC_EnableIRQ()`
- `HAL_GPIO_EXTI_IRQHandler()` → `HAL_GPIO_EXTI_Callback()` zinciri
- `volatile uint8_t` flag ile ISR → ana döngü iletişimi

## Kod Özeti
```c
// ISR
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) {
  if (GPIO_Pin == B1_Pin) btn_pressed = 1;
}

// Ana döngü
if (btn_pressed) { btn_pressed = 0; HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin); }
```

## Çıktı
- **B1** düğmesine her basıldığında **LD2** toggle olur (yanar/söner)

## Kurulum & Çalıştırma
```bash
make -C 04_EXTI_Interrupt
st-flash write 04_EXTI_Interrupt/build/04_EXTI_Interrupt.bin 0x08000000
```

## Öğrenilenler
- Kesme yapılandırması ve NVIC öncelik mantığı
- ISR'de kısa iş yapıp ağır işi ana döngüye bırakma
- Debounce ve volatile flag kullanımı
