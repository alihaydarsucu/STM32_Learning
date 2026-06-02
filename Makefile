# top-level Makefile - build every phase project.
#
# Optional overrides:
#   make CROSS_COMPILE=/path/to/arm-none-eabi-   (explicit toolchain)
#   make PHASES="01_UART_Control 03_ADC_Read"    (subset of phases)

PHASES := 00_LED_Blink 01_UART_Control 02_PWM_Output 03_ADC_Read \
          04_EXTI_Interrupt 05_I2C_OLED 06_Timer_InputCapture 07_FreeRTOS

.PHONY: all clean flash $(PHASES)

all: $(PHASES)

$(PHASES):
	$(MAKE) -C $@

clean:
	@for p in $(PHASES); do $(MAKE) -C $$p clean; done

flash:
	@echo "Pick a phase, e.g.: make -C 02_PWM_Output flash"
