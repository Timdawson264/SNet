#pragma once

#include "stm8s_conf.h"


void 
systick_init(void);

uint32_t 
systick_ticks_us(void);

uint32_t 
systick_epoch_ms(void);

void 
systick_delayms(uint32_t ms);

void 
systick_delayus(uint32_t us);