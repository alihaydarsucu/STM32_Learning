# STM32F103RB Learning Journey

This repository documents my embedded systems learning journey using the **STM32 NUCLEO-F103RB** development board.  
The focus is on understanding STM32 peripherals through practical examples using **STM32CubeIDE** and the **HAL library**.


## Project Steps

### ✅ 00 – LED Blink
- GPIO configuration
- Basic LED control using HAL
- Status: **Completed**


### ✅ 01 – UART Control
- Serial communication using **USART2**
- LED control via terminal commands
- Configuration: **115200 baud, 8N1**
- Status: **Completed**

### 🟡 02 – PWM Output (In Progress)
- PWM generation using **TIM2 (Channel 1)**
- Duty cycle control via CCR register
- Configured using HAL
- Hardware output available on **PA0 (TIM2_CH1)**
- Status: **In Progress**


## Hardware & Software

- **Board:** NUCLEO-F103RB  
- **MCU:** STM32F103RBT6  
- **IDE:** STM32CubeIDE 1.19.0  
- **OS:** Arch Linux  


## Notes

- Virtual COM Port: `/dev/ttyACM0`
- ST-LINK firmware: **V2J46M33**
- UART communication tested via terminal
