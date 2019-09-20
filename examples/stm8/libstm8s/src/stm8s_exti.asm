;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Apr  3 2018) (Linux)
; This file was generated Fri Sep 20 09:49:49 2019
;--------------------------------------------------------
	.module stm8s_exti
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _EXTI_DeInit
	.globl _EXTI_SetExtIntSensitivity
	.globl _EXTI_SetTLISensitivity
	.globl _EXTI_GetExtIntSensitivity
	.globl _EXTI_GetTLISensitivity
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	libstm8s/src/stm8s_exti.c: 53: void EXTI_DeInit(void)
;	-----------------------------------------
;	 function EXTI_DeInit
;	-----------------------------------------
_EXTI_DeInit:
;	libstm8s/src/stm8s_exti.c: 55: EXTI->CR1 = EXTI_CR1_RESET_VALUE;
	mov	0x50a0+0, #0x00
;	libstm8s/src/stm8s_exti.c: 56: EXTI->CR2 = EXTI_CR2_RESET_VALUE;
	mov	0x50a1+0, #0x00
	ret
;	libstm8s/src/stm8s_exti.c: 70: void EXTI_SetExtIntSensitivity(EXTI_Port_TypeDef Port, EXTI_Sensitivity_TypeDef SensitivityValue)
;	-----------------------------------------
;	 function EXTI_SetExtIntSensitivity
;	-----------------------------------------
_EXTI_SetExtIntSensitivity:
	sub	sp, #3
;	libstm8s/src/stm8s_exti.c: 77: switch (Port)
	ld	a, (0x06, sp)
	cp	a, #0x04
	jrule	00114$
	jp	00108$
00114$:
	clrw	x
	ld	a, (0x06, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00115$, x)
	jp	(x)
00115$:
	.dw	#00101$
	.dw	#00102$
	.dw	#00103$
	.dw	#00104$
	.dw	#00105$
;	libstm8s/src/stm8s_exti.c: 79: case EXTI_PORT_GPIOA:
00101$:
;	libstm8s/src/stm8s_exti.c: 80: EXTI->CR1 &= (uint8_t)(~EXTI_CR1_PAIS);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0xfc
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 81: EXTI->CR1 |= (uint8_t)(SensitivityValue);
	ldw	x, #0x50a0
	ld	a, (x)
	or	a, (0x07, sp)
	ldw	x, #0x50a0
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 82: break;
	jra	00108$
;	libstm8s/src/stm8s_exti.c: 83: case EXTI_PORT_GPIOB:
00102$:
;	libstm8s/src/stm8s_exti.c: 84: EXTI->CR1 &= (uint8_t)(~EXTI_CR1_PBIS);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0xf3
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 85: EXTI->CR1 |= (uint8_t)((uint8_t)(SensitivityValue) << 2);
	ldw	x, #0x50a0
	ld	a, (x)
	ld	(0x01, sp), a
	ld	a, (0x07, sp)
	sll	a
	sll	a
	or	a, (0x01, sp)
	ldw	x, #0x50a0
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 86: break;
	jra	00108$
;	libstm8s/src/stm8s_exti.c: 87: case EXTI_PORT_GPIOC:
00103$:
;	libstm8s/src/stm8s_exti.c: 88: EXTI->CR1 &= (uint8_t)(~EXTI_CR1_PCIS);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0xcf
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 89: EXTI->CR1 |= (uint8_t)((uint8_t)(SensitivityValue) << 4);
	ldw	x, #0x50a0
	ld	a, (x)
	ld	(0x02, sp), a
	ld	a, (0x07, sp)
	swap	a
	and	a, #0xf0
	or	a, (0x02, sp)
	ldw	x, #0x50a0
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 90: break;
	jra	00108$
;	libstm8s/src/stm8s_exti.c: 91: case EXTI_PORT_GPIOD:
00104$:
;	libstm8s/src/stm8s_exti.c: 92: EXTI->CR1 &= (uint8_t)(~EXTI_CR1_PDIS);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0x3f
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 93: EXTI->CR1 |= (uint8_t)((uint8_t)(SensitivityValue) << 6);
	ldw	x, #0x50a0
	ld	a, (x)
	ld	(0x03, sp), a
	ld	a, (0x07, sp)
	swap	a
	and	a, #0xf0
	sll	a
	sll	a
	or	a, (0x03, sp)
	ldw	x, #0x50a0
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 94: break;
	jra	00108$
;	libstm8s/src/stm8s_exti.c: 95: case EXTI_PORT_GPIOE:
00105$:
;	libstm8s/src/stm8s_exti.c: 96: EXTI->CR2 &= (uint8_t)(~EXTI_CR2_PEIS);
	ldw	x, #0x50a1
	ld	a, (x)
	and	a, #0xfc
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 97: EXTI->CR2 |= (uint8_t)(SensitivityValue);
	ldw	x, #0x50a1
	ld	a, (x)
	or	a, (0x07, sp)
	ldw	x, #0x50a1
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 101: }
00108$:
	addw	sp, #3
	ret
;	libstm8s/src/stm8s_exti.c: 111: void EXTI_SetTLISensitivity(EXTI_TLISensitivity_TypeDef SensitivityValue)
;	-----------------------------------------
;	 function EXTI_SetTLISensitivity
;	-----------------------------------------
_EXTI_SetTLISensitivity:
;	libstm8s/src/stm8s_exti.c: 117: EXTI->CR2 &= (uint8_t)(~EXTI_CR2_TLIS);
	ldw	x, #0x50a1
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
;	libstm8s/src/stm8s_exti.c: 118: EXTI->CR2 |= (uint8_t)(SensitivityValue);
	ldw	x, #0x50a1
	ld	a, (x)
	or	a, (0x03, sp)
	ldw	x, #0x50a1
	ld	(x), a
	ret
;	libstm8s/src/stm8s_exti.c: 126: EXTI_Sensitivity_TypeDef EXTI_GetExtIntSensitivity(EXTI_Port_TypeDef Port)
;	-----------------------------------------
;	 function EXTI_GetExtIntSensitivity
;	-----------------------------------------
_EXTI_GetExtIntSensitivity:
;	libstm8s/src/stm8s_exti.c: 128: uint8_t value = 0;
	clr	a
;	libstm8s/src/stm8s_exti.c: 133: switch (Port)
	push	a
	ld	a, (0x04, sp)
	cp	a, #0x04
	pop	a
	jrugt	00107$
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00115$, x)
	jp	(x)
00115$:
	.dw	#00101$
	.dw	#00102$
	.dw	#00103$
	.dw	#00104$
	.dw	#00105$
;	libstm8s/src/stm8s_exti.c: 135: case EXTI_PORT_GPIOA:
00101$:
;	libstm8s/src/stm8s_exti.c: 136: value = (uint8_t)(EXTI->CR1 & EXTI_CR1_PAIS);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0x03
;	libstm8s/src/stm8s_exti.c: 137: break;
	jra	00107$
;	libstm8s/src/stm8s_exti.c: 138: case EXTI_PORT_GPIOB:
00102$:
;	libstm8s/src/stm8s_exti.c: 139: value = (uint8_t)((uint8_t)(EXTI->CR1 & EXTI_CR1_PBIS) >> 2);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0x0c
	srl	a
	srl	a
;	libstm8s/src/stm8s_exti.c: 140: break;
	jra	00107$
;	libstm8s/src/stm8s_exti.c: 141: case EXTI_PORT_GPIOC:
00103$:
;	libstm8s/src/stm8s_exti.c: 142: value = (uint8_t)((uint8_t)(EXTI->CR1 & EXTI_CR1_PCIS) >> 4);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0x30
	swap	a
	and	a, #0x0f
;	libstm8s/src/stm8s_exti.c: 143: break;
	jra	00107$
;	libstm8s/src/stm8s_exti.c: 144: case EXTI_PORT_GPIOD:
00104$:
;	libstm8s/src/stm8s_exti.c: 145: value = (uint8_t)((uint8_t)(EXTI->CR1 & EXTI_CR1_PDIS) >> 6);
	ldw	x, #0x50a0
	ld	a, (x)
	and	a, #0xc0
	swap	a
	and	a, #0x0f
	srl	a
	srl	a
;	libstm8s/src/stm8s_exti.c: 146: break;
	jra	00107$
;	libstm8s/src/stm8s_exti.c: 147: case EXTI_PORT_GPIOE:
00105$:
;	libstm8s/src/stm8s_exti.c: 148: value = (uint8_t)(EXTI->CR2 & EXTI_CR2_PEIS);
	ldw	x, #0x50a1
	ld	a, (x)
	and	a, #0x03
;	libstm8s/src/stm8s_exti.c: 152: }
00107$:
;	libstm8s/src/stm8s_exti.c: 154: return((EXTI_Sensitivity_TypeDef)value);
	ret
;	libstm8s/src/stm8s_exti.c: 162: EXTI_TLISensitivity_TypeDef EXTI_GetTLISensitivity(void)
;	-----------------------------------------
;	 function EXTI_GetTLISensitivity
;	-----------------------------------------
_EXTI_GetTLISensitivity:
;	libstm8s/src/stm8s_exti.c: 167: value = (uint8_t)(EXTI->CR2 & EXTI_CR2_TLIS);
	ldw	x, #0x50a1
	ld	a, (x)
	and	a, #0x04
;	libstm8s/src/stm8s_exti.c: 169: return((EXTI_TLISensitivity_TypeDef)value);
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
