#pragma once

#include "stm32f1xx_hal.h"


void
LED_init();

void 
setPWM(uint32_t channel, uint16_t pulse);