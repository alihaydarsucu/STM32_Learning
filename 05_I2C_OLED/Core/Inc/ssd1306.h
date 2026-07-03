/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    ssd1306.h
  * @brief   Minimal I2C driver for the SSD1306 OLED (128x64).
  ******************************************************************************
  * @attention
  *
  * Lightweight, self-contained SSD1306 driver built on the STM32 HAL I2C.
  * Supports the common 128x64 monochrome OLED modules (I2C address 0x3C/0x3D).
  *
  ******************************************************************************
  */
/* USER CODE END Header */

#ifndef __SSD1306_H
#define __SSD1306_H

#include "stm32f1xx_hal.h"

/* I2C address (default 0x3C for most modules). */
#define SSD1306_I2C_ADDR   (0x3C << 1)
#define SSD1306_WIDTH      128
#define SSD1306_HEIGHT     64

typedef enum {
  SSD1306_COLOR_BLACK = 0,
  SSD1306_COLOR_WHITE = 1,
} SSD1306_COLOR_t;

typedef struct {
  I2C_HandleTypeDef *hi2c;
  uint8_t buffer[SSD1306_WIDTH * SSD1306_HEIGHT / 8];
} SSD1306_t;

/* Control-byte prefixes */
#define SSD1306_CTRL_CMD   0x00
#define SSD1306_CTRL_DATA  0x40

/* Basic commands */
#define SSD1306_CMD_DISPLAY_OFF      0xAE
#define SSD1306_CMD_DISPLAY_ON       0xAF
#define SSD1306_CMD_SET_MEM_MODE     0x20
#define SSD1306_CMD_SET_COL_ADDR     0x21
#define SSD1306_CMD_SET_PAGE_ADDR    0x22

uint8_t  SSD1306_Init(SSD1306_t *oled, I2C_HandleTypeDef *hi2c);
void     SSD1306_Clear(SSD1306_t *oled);
void     SSD1306_Fill(SSD1306_t *oled, SSD1306_COLOR_t color);
void     SSD1306_Update(SSD1306_t *oled);
void     SSD1306_DrawPixel(SSD1306_t *oled, uint16_t x, uint16_t y, SSD1306_COLOR_t color);
void     SSD1306_DrawChar(SSD1306_t *oled, uint16_t x, uint16_t y, char ch, SSD1306_COLOR_t color);
void     SSD1306_WriteString(SSD1306_t *oled, uint16_t x, uint16_t y, const char *str,
                             SSD1306_COLOR_t color, uint8_t size);

#endif /* __SSD1306_H */
