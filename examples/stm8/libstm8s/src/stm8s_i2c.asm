;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Apr  3 2018) (Linux)
; This file was generated Fri Sep 20 09:49:48 2019
;--------------------------------------------------------
	.module stm8s_i2c
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _I2C_DeInit
	.globl _I2C_Init
	.globl _I2C_Cmd
	.globl _I2C_GeneralCallCmd
	.globl _I2C_GenerateSTART
	.globl _I2C_GenerateSTOP
	.globl _I2C_SoftwareResetCmd
	.globl _I2C_StretchClockCmd
	.globl _I2C_AcknowledgeConfig
	.globl _I2C_ITConfig
	.globl _I2C_FastModeDutyCycleConfig
	.globl _I2C_ReceiveData
	.globl _I2C_Send7bitAddress
	.globl _I2C_SendData
	.globl _I2C_CheckEvent
	.globl _I2C_GetLastEvent
	.globl _I2C_GetFlagStatus
	.globl _I2C_ClearFlag
	.globl _I2C_GetITStatus
	.globl _I2C_ClearITPendingBit
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
;	libstm8s/src/stm8s_i2c.c: 67: void I2C_DeInit(void)
;	-----------------------------------------
;	 function I2C_DeInit
;	-----------------------------------------
_I2C_DeInit:
;	libstm8s/src/stm8s_i2c.c: 69: I2C->CR1 = I2C_CR1_RESET_VALUE;
	mov	0x5210+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 70: I2C->CR2 = I2C_CR2_RESET_VALUE;
	mov	0x5211+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 71: I2C->FREQR = I2C_FREQR_RESET_VALUE;
	mov	0x5212+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 72: I2C->OARL = I2C_OARL_RESET_VALUE;
	mov	0x5213+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 73: I2C->OARH = I2C_OARH_RESET_VALUE;
	mov	0x5214+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 74: I2C->ITR = I2C_ITR_RESET_VALUE;
	mov	0x521a+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 75: I2C->CCRL = I2C_CCRL_RESET_VALUE;
	mov	0x521b+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 76: I2C->CCRH = I2C_CCRH_RESET_VALUE;
	mov	0x521c+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 77: I2C->TRISER = I2C_TRISER_RESET_VALUE;
	mov	0x521d+0, #0x02
	ret
;	libstm8s/src/stm8s_i2c.c: 96: void I2C_Init(uint32_t OutputClockFrequencyHz, uint16_t OwnAddress, 
;	-----------------------------------------
;	 function I2C_Init
;	-----------------------------------------
_I2C_Init:
	sub	sp, #10
;	libstm8s/src/stm8s_i2c.c: 102: uint8_t tmpccrh = 0;
	clr	(0x03, sp)
;	libstm8s/src/stm8s_i2c.c: 115: I2C->FREQR &= (uint8_t)(~I2C_FREQR_FREQ);
	ldw	x, #0x5212
	ld	a, (x)
	and	a, #0xc0
	ld	(x), a
;	libstm8s/src/stm8s_i2c.c: 117: I2C->FREQR |= InputClockFrequencyMHz;
	ldw	x, #0x5212
	ld	a, (x)
	or	a, (0x16, sp)
	ldw	x, #0x5212
	ld	(x), a
;	libstm8s/src/stm8s_i2c.c: 121: I2C->CR1 &= (uint8_t)(~I2C_CR1_PE);
	bres	0x5210, #0
;	libstm8s/src/stm8s_i2c.c: 124: I2C->CCRH &= (uint8_t)(~(I2C_CCRH_FS | I2C_CCRH_DUTY | I2C_CCRH_CCR));
	ldw	x, #0x521c
	ld	a, (x)
	and	a, #0x30
	ld	(x), a
;	libstm8s/src/stm8s_i2c.c: 125: I2C->CCRL &= (uint8_t)(~I2C_CCRL_CCR);
	ldw	x, #0x521b
	ld	a, (x)
	mov	0x521b+0, #0x00
;	libstm8s/src/stm8s_i2c.c: 136: result = (uint16_t) ((InputClockFrequencyMHz * 1000000) / (OutputClockFrequencyHz * 3));
	clrw	x
	ld	a, (0x16, sp)
	ld	xl, a
	clrw	y
	pushw	x
	pushw	y
	push	#0x40
	push	#0x42
	push	#0x0f
	push	#0x00
	call	__mullong
	addw	sp, #8
	ldw	(0x09, sp), x
	ldw	(0x07, sp), y
;	libstm8s/src/stm8s_i2c.c: 128: if (OutputClockFrequencyHz > I2C_MAX_STANDARD_FREQ) /* FAST MODE */
	ldw	x, #0x86a0
	cpw	x, (0x0f, sp)
	ld	a, #0x01
	sbc	a, (0x0e, sp)
	clr	a
	sbc	a, (0x0d, sp)
	jrnc	00109$
;	libstm8s/src/stm8s_i2c.c: 131: tmpccrh = I2C_CCRH_FS;
	ld	a, #0x80
	ld	(0x03, sp), a
;	libstm8s/src/stm8s_i2c.c: 133: if (I2C_DutyCycle == I2C_DUTYCYCLE_2)
	tnz	(0x13, sp)
	jrne	00102$
;	libstm8s/src/stm8s_i2c.c: 136: result = (uint16_t) ((InputClockFrequencyMHz * 1000000) / (OutputClockFrequencyHz * 3));
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	push	#0x03
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	__divulong
	addw	sp, #8
	ldw	(0x01, sp), x
	jra	00103$
00102$:
;	libstm8s/src/stm8s_i2c.c: 141: result = (uint16_t) ((InputClockFrequencyMHz * 1000000) / (OutputClockFrequencyHz * 25));
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	push	#0x19
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	pushw	y
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	__divulong
	addw	sp, #8
	ldw	(0x01, sp), x
;	libstm8s/src/stm8s_i2c.c: 143: tmpccrh |= I2C_CCRH_DUTY;
	ld	a, #0xc0
	ld	(0x03, sp), a
00103$:
;	libstm8s/src/stm8s_i2c.c: 147: if (result < (uint16_t)0x01)
	ldw	x, (0x01, sp)
	cpw	x, #0x0001
	jrnc	00105$
;	libstm8s/src/stm8s_i2c.c: 150: result = (uint16_t)0x0001;
	ldw	x, #0x0001
	ldw	(0x01, sp), x
00105$:
;	libstm8s/src/stm8s_i2c.c: 156: tmpval = ((InputClockFrequencyMHz * 3) / 10) + 1;
	ld	a, (0x16, sp)
	ld	xl, a
	ld	a, #0x03
	mul	x, a
	push	#0x0a
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	incw	x
	ld	a, xl
;	libstm8s/src/stm8s_i2c.c: 157: I2C->TRISER = (uint8_t)tmpval;
	ldw	x, #0x521d
	ld	(x), a
	jra	00110$
00109$:
;	libstm8s/src/stm8s_i2c.c: 164: result = (uint16_t)((InputClockFrequencyMHz * 1000000) / (OutputClockFrequencyHz << (uint8_t)1));
	ldw	y, (0x0f, sp)
	ldw	x, (0x0d, sp)
	sllw	y
	rlcw	x
	pushw	y
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x0d, sp)
	pushw	x
	call	__divulong
	addw	sp, #8
	ldw	(0x01, sp), x
;	libstm8s/src/stm8s_i2c.c: 167: if (result < (uint16_t)0x0004)
	ldw	x, (0x01, sp)
	cpw	x, #0x0004
	jrnc	00107$
;	libstm8s/src/stm8s_i2c.c: 170: result = (uint16_t)0x0004;
	ldw	x, #0x0004
	ldw	(0x01, sp), x
00107$:
;	libstm8s/src/stm8s_i2c.c: 176: I2C->TRISER = (uint8_t)(InputClockFrequencyMHz + (uint8_t)1);
	ld	a, (0x16, sp)
	inc	a
	ldw	x, #0x521d
	ld	(x), a
00110$:
;	libstm8s/src/stm8s_i2c.c: 181: I2C->CCRL = (uint8_t)result;
	ld	a, (0x02, sp)
	ldw	x, #0x521b
	ld	(x), a
;	libstm8s/src/stm8s_i2c.c: 182: I2C->CCRH = (uint8_t)((uint8_t)((uint8_t)(result >> 8) & I2C_CCRH_CCR) | tmpccrh);
	ld	a, (0x01, sp)
	clr	(0x05, sp)
	and	a, #0x0f
	or	a, (0x03, sp)
	ldw	x, #0x521c
	ld	(x), a
;	libstm8s/src/stm8s_i2c.c: 185: I2C->CR1 |= I2C_CR1_PE;
	bset	0x5210, #0
;	libstm8s/src/stm8s_i2c.c: 188: I2C_AcknowledgeConfig(Ack);
	ld	a, (0x14, sp)
	push	a
	call	_I2C_AcknowledgeConfig
	pop	a
;	libstm8s/src/stm8s_i2c.c: 191: I2C->OARL = (uint8_t)(OwnAddress);
	ld	a, (0x12, sp)
	ldw	x, #0x5213
	ld	(x), a
;	libstm8s/src/stm8s_i2c.c: 192: I2C->OARH = (uint8_t)((uint8_t)(AddMode | I2C_OARH_ADDCONF) |
	ld	a, (0x15, sp)
	or	a, #0x40
	ld	(0x04, sp), a
;	libstm8s/src/stm8s_i2c.c: 193: (uint8_t)((OwnAddress & (uint16_t)0x0300) >> (uint8_t)7));
	clr	a
	ld	xl, a
	ld	a, (0x11, sp)
	and	a, #0x03
	ld	xh, a
	ld	a, #0x80
	div	x, a
	ld	a, xl
	or	a, (0x04, sp)
	ldw	x, #0x5214
	ld	(x), a
	addw	sp, #10
	ret
;	libstm8s/src/stm8s_i2c.c: 202: void I2C_Cmd(FunctionalState NewState)
;	-----------------------------------------
;	 function I2C_Cmd
;	-----------------------------------------
_I2C_Cmd:
;	libstm8s/src/stm8s_i2c.c: 207: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 210: I2C->CR1 |= I2C_CR1_PE;
	bset	0x5210, #0
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 215: I2C->CR1 &= (uint8_t)(~I2C_CR1_PE);
	bres	0x5210, #0
00104$:
	ret
;	libstm8s/src/stm8s_i2c.c: 225: void I2C_GeneralCallCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function I2C_GeneralCallCmd
;	-----------------------------------------
_I2C_GeneralCallCmd:
;	libstm8s/src/stm8s_i2c.c: 230: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 233: I2C->CR1 |= I2C_CR1_ENGC;
	ldw	x, #0x5210
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 238: I2C->CR1 &= (uint8_t)(~I2C_CR1_ENGC);
	ldw	x, #0x5210
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_i2c.c: 250: void I2C_GenerateSTART(FunctionalState NewState)
;	-----------------------------------------
;	 function I2C_GenerateSTART
;	-----------------------------------------
_I2C_GenerateSTART:
;	libstm8s/src/stm8s_i2c.c: 255: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 258: I2C->CR2 |= I2C_CR2_START;
	bset	0x5211, #0
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 263: I2C->CR2 &= (uint8_t)(~I2C_CR2_START);
	bres	0x5211, #0
00104$:
	ret
;	libstm8s/src/stm8s_i2c.c: 273: void I2C_GenerateSTOP(FunctionalState NewState)
;	-----------------------------------------
;	 function I2C_GenerateSTOP
;	-----------------------------------------
_I2C_GenerateSTOP:
;	libstm8s/src/stm8s_i2c.c: 278: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 281: I2C->CR2 |= I2C_CR2_STOP;
	ldw	x, #0x5211
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 286: I2C->CR2 &= (uint8_t)(~I2C_CR2_STOP);
	ldw	x, #0x5211
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_i2c.c: 296: void I2C_SoftwareResetCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function I2C_SoftwareResetCmd
;	-----------------------------------------
_I2C_SoftwareResetCmd:
;	libstm8s/src/stm8s_i2c.c: 301: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 304: I2C->CR2 |= I2C_CR2_SWRST;
	bset	0x5211, #7
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 309: I2C->CR2 &= (uint8_t)(~I2C_CR2_SWRST);
	bres	0x5211, #7
00104$:
	ret
;	libstm8s/src/stm8s_i2c.c: 320: void I2C_StretchClockCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function I2C_StretchClockCmd
;	-----------------------------------------
_I2C_StretchClockCmd:
;	libstm8s/src/stm8s_i2c.c: 325: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 328: I2C->CR1 &= (uint8_t)(~I2C_CR1_NOSTRETCH);
	bres	0x5210, #7
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 334: I2C->CR1 |= I2C_CR1_NOSTRETCH;
	bset	0x5210, #7
00104$:
	ret
;	libstm8s/src/stm8s_i2c.c: 345: void I2C_AcknowledgeConfig(I2C_Ack_TypeDef Ack)
;	-----------------------------------------
;	 function I2C_AcknowledgeConfig
;	-----------------------------------------
_I2C_AcknowledgeConfig:
;	libstm8s/src/stm8s_i2c.c: 350: if (Ack == I2C_ACK_NONE)
	tnz	(0x03, sp)
	jrne	00105$
;	libstm8s/src/stm8s_i2c.c: 353: I2C->CR2 &= (uint8_t)(~I2C_CR2_ACK);
	ldw	x, #0x5211
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	jra	00107$
00105$:
;	libstm8s/src/stm8s_i2c.c: 358: I2C->CR2 |= I2C_CR2_ACK;
	ldw	x, #0x5211
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
;	libstm8s/src/stm8s_i2c.c: 360: if (Ack == I2C_ACK_CURR)
	ld	a, (0x03, sp)
	cp	a, #0x01
	jrne	00102$
;	libstm8s/src/stm8s_i2c.c: 363: I2C->CR2 &= (uint8_t)(~I2C_CR2_POS);
	ldw	x, #0x5211
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	jra	00107$
00102$:
;	libstm8s/src/stm8s_i2c.c: 368: I2C->CR2 |= I2C_CR2_POS;
	ldw	x, #0x5211
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
00107$:
	ret
;	libstm8s/src/stm8s_i2c.c: 381: void I2C_ITConfig(I2C_IT_TypeDef I2C_IT, FunctionalState NewState)
;	-----------------------------------------
;	 function I2C_ITConfig
;	-----------------------------------------
_I2C_ITConfig:
	push	a
;	libstm8s/src/stm8s_i2c.c: 387: if (NewState != DISABLE)
	tnz	(0x05, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 390: I2C->ITR |= (uint8_t)I2C_IT;
	ldw	x, #0x521a
	ld	a, (x)
	or	a, (0x04, sp)
	ldw	x, #0x521a
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 395: I2C->ITR &= (uint8_t)(~(uint8_t)I2C_IT);
	ldw	x, #0x521a
	ld	a, (x)
	ld	(0x01, sp), a
	ld	a, (0x04, sp)
	cpl	a
	and	a, (0x01, sp)
	ldw	x, #0x521a
	ld	(x), a
00104$:
	pop	a
	ret
;	libstm8s/src/stm8s_i2c.c: 405: void I2C_FastModeDutyCycleConfig(I2C_DutyCycle_TypeDef I2C_DutyCycle)
;	-----------------------------------------
;	 function I2C_FastModeDutyCycleConfig
;	-----------------------------------------
_I2C_FastModeDutyCycleConfig:
;	libstm8s/src/stm8s_i2c.c: 410: if (I2C_DutyCycle == I2C_DUTYCYCLE_16_9)
	ld	a, (0x03, sp)
	cp	a, #0x40
	jrne	00102$
;	libstm8s/src/stm8s_i2c.c: 413: I2C->CCRH |= I2C_CCRH_DUTY;
	ldw	x, #0x521c
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_i2c.c: 418: I2C->CCRH &= (uint8_t)(~I2C_CCRH_DUTY);
	ldw	x, #0x521c
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_i2c.c: 427: uint8_t I2C_ReceiveData(void)
;	-----------------------------------------
;	 function I2C_ReceiveData
;	-----------------------------------------
_I2C_ReceiveData:
;	libstm8s/src/stm8s_i2c.c: 430: return ((uint8_t)I2C->DR);
	ldw	x, #0x5216
	ld	a, (x)
	ret
;	libstm8s/src/stm8s_i2c.c: 440: void I2C_Send7bitAddress(uint8_t Address, I2C_Direction_TypeDef Direction)
;	-----------------------------------------
;	 function I2C_Send7bitAddress
;	-----------------------------------------
_I2C_Send7bitAddress:
;	libstm8s/src/stm8s_i2c.c: 447: Address &= (uint8_t)0xFE;
	ld	a, (0x03, sp)
	and	a, #0xfe
	ld	(0x03, sp), a
;	libstm8s/src/stm8s_i2c.c: 450: I2C->DR = (uint8_t)(Address | (uint8_t)Direction);
	ld	a, (0x03, sp)
	or	a, (0x04, sp)
	ldw	x, #0x5216
	ld	(x), a
	ret
;	libstm8s/src/stm8s_i2c.c: 458: void I2C_SendData(uint8_t Data)
;	-----------------------------------------
;	 function I2C_SendData
;	-----------------------------------------
_I2C_SendData:
;	libstm8s/src/stm8s_i2c.c: 461: I2C->DR = Data;
	ldw	x, #0x5216
	ld	a, (0x03, sp)
	ld	(x), a
	ret
;	libstm8s/src/stm8s_i2c.c: 578: ErrorStatus I2C_CheckEvent(I2C_Event_TypeDef I2C_Event)
;	-----------------------------------------
;	 function I2C_CheckEvent
;	-----------------------------------------
_I2C_CheckEvent:
	sub	sp, #10
;	libstm8s/src/stm8s_i2c.c: 580: __IO uint16_t lastevent = 0x00;
	clrw	x
	ldw	(0x01, sp), x
;	libstm8s/src/stm8s_i2c.c: 588: if (I2C_Event == I2C_EVENT_SLAVE_ACK_FAILURE)
	ldw	x, (0x0d, sp)
	cpw	x, #0x0004
	jrne	00102$
;	libstm8s/src/stm8s_i2c.c: 590: lastevent = I2C->SR2 & I2C_SR2_AF;
	ldw	x, #0x5218
	ld	a, (x)
	and	a, #0x04
	clrw	x
	ld	xl, a
	ldw	(0x01, sp), x
	jra	00103$
00102$:
;	libstm8s/src/stm8s_i2c.c: 594: flag1 = I2C->SR1;
	ldw	x, #0x5217
	ld	a, (x)
;	libstm8s/src/stm8s_i2c.c: 595: flag2 = I2C->SR3;
	ldw	x, #0x5219
	push	a
	ld	a, (x)
	ld	xh, a
	pop	a
;	libstm8s/src/stm8s_i2c.c: 596: lastevent = ((uint16_t)((uint16_t)flag2 << (uint16_t)8) | (uint16_t)flag1);
	clr	(0x05, sp)
	clr	(0x04, sp)
	clr	(0x09, sp)
	or	a, (0x04, sp)
	ld	(0x08, sp), a
	ld	a, xh
	or	a, (0x09, sp)
	ld	(0x01, sp), a
	ld	a, (0x08, sp)
	ld	(0x02, sp), a
00103$:
;	libstm8s/src/stm8s_i2c.c: 599: if (((uint16_t)lastevent & (uint16_t)I2C_Event) == (uint16_t)I2C_Event)
	ld	a, (0x02, sp)
	and	a, (0x0e, sp)
	ld	xl, a
	ld	a, (0x01, sp)
	and	a, (0x0d, sp)
	ld	xh, a
	cpw	x, (0x0d, sp)
	jrne	00105$
;	libstm8s/src/stm8s_i2c.c: 602: status = SUCCESS;
	ld	a, #0x01
;	libstm8s/src/stm8s_i2c.c: 607: status = ERROR;
	.byte 0x21
00105$:
	clr	a
00106$:
;	libstm8s/src/stm8s_i2c.c: 611: return status;
	addw	sp, #10
	ret
;	libstm8s/src/stm8s_i2c.c: 628: I2C_Event_TypeDef I2C_GetLastEvent(void)
;	-----------------------------------------
;	 function I2C_GetLastEvent
;	-----------------------------------------
_I2C_GetLastEvent:
	sub	sp, #4
;	libstm8s/src/stm8s_i2c.c: 630: __IO uint16_t lastevent = 0;
	clrw	x
	ldw	(0x01, sp), x
;	libstm8s/src/stm8s_i2c.c: 634: if ((I2C->SR2 & I2C_SR2_AF) != 0x00)
	ldw	x, #0x5218
	ld	a, (x)
	bcp	a, #0x04
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 636: lastevent = I2C_EVENT_SLAVE_ACK_FAILURE;
	ldw	x, #0x0004
	ldw	(0x01, sp), x
	jra	00103$
00102$:
;	libstm8s/src/stm8s_i2c.c: 641: flag1 = I2C->SR1;
	ldw	x, #0x5217
	ld	a, (x)
	clrw	x
	ld	xl, a
	ldw	(0x03, sp), x
;	libstm8s/src/stm8s_i2c.c: 642: flag2 = I2C->SR3;
	ldw	x, #0x5219
	ld	a, (x)
	ld	xh, a
	clr	a
;	libstm8s/src/stm8s_i2c.c: 645: lastevent = ((uint16_t)((uint16_t)flag2 << 8) | (uint16_t)flag1);
	clr	a
	or	a, (0x04, sp)
	rlwa	x
	or	a, (0x03, sp)
	ld	xh, a
	ldw	(0x01, sp), x
00103$:
;	libstm8s/src/stm8s_i2c.c: 648: return (I2C_Event_TypeDef)lastevent;
	ldw	x, (0x01, sp)
	addw	sp, #4
	ret
;	libstm8s/src/stm8s_i2c.c: 679: FlagStatus I2C_GetFlagStatus(I2C_Flag_TypeDef I2C_Flag)
;	-----------------------------------------
;	 function I2C_GetFlagStatus
;	-----------------------------------------
_I2C_GetFlagStatus:
	pushw	x
;	libstm8s/src/stm8s_i2c.c: 681: uint8_t tempreg = 0;
	clr	a
	ld	xh, a
;	libstm8s/src/stm8s_i2c.c: 689: regindex = (uint8_t)((uint16_t)I2C_Flag >> 8);
	ld	a, (0x05, sp)
	clr	(0x01, sp)
;	libstm8s/src/stm8s_i2c.c: 691: switch (regindex)
	cp	a, #0x01
	jreq	00101$
	cp	a, #0x02
	jreq	00102$
	cp	a, #0x03
	jreq	00103$
	jra	00105$
;	libstm8s/src/stm8s_i2c.c: 694: case 0x01:
00101$:
;	libstm8s/src/stm8s_i2c.c: 695: tempreg = (uint8_t)I2C->SR1;
	ldw	x, #0x5217
	ld	a, (x)
	ld	xh, a
;	libstm8s/src/stm8s_i2c.c: 696: break;
	jra	00105$
;	libstm8s/src/stm8s_i2c.c: 699: case 0x02:
00102$:
;	libstm8s/src/stm8s_i2c.c: 700: tempreg = (uint8_t)I2C->SR2;
	ldw	x, #0x5218
	ld	a, (x)
	ld	xh, a
;	libstm8s/src/stm8s_i2c.c: 701: break;
	jra	00105$
;	libstm8s/src/stm8s_i2c.c: 704: case 0x03:
00103$:
;	libstm8s/src/stm8s_i2c.c: 705: tempreg = (uint8_t)I2C->SR3;
	ldw	x, #0x5219
	ld	a, (x)
	ld	xh, a
;	libstm8s/src/stm8s_i2c.c: 710: }
00105$:
;	libstm8s/src/stm8s_i2c.c: 713: if ((tempreg & (uint8_t)I2C_Flag ) != 0)
	ld	a, (0x06, sp)
	pushw	x
	and	a, (1, sp)
	popw	x
	tnz	a
	jreq	00107$
;	libstm8s/src/stm8s_i2c.c: 716: bitstatus = SET;
	ld	a, #0x01
;	libstm8s/src/stm8s_i2c.c: 721: bitstatus = RESET;
	.byte 0x21
00107$:
	clr	a
00108$:
;	libstm8s/src/stm8s_i2c.c: 724: return bitstatus;
	popw	x
	ret
;	libstm8s/src/stm8s_i2c.c: 759: void I2C_ClearFlag(I2C_Flag_TypeDef I2C_FLAG)
;	-----------------------------------------
;	 function I2C_ClearFlag
;	-----------------------------------------
_I2C_ClearFlag:
;	libstm8s/src/stm8s_i2c.c: 766: flagpos = (uint16_t)I2C_FLAG & FLAG_Mask;
	ld	a, (0x04, sp)
	ld	xl, a
	clr	a
	ld	xh, a
;	libstm8s/src/stm8s_i2c.c: 768: I2C->SR2 = (uint8_t)((uint16_t)(~flagpos));
	cplw	x
	ld	a, xl
	ldw	x, #0x5218
	ld	(x), a
	ret
;	libstm8s/src/stm8s_i2c.c: 791: ITStatus I2C_GetITStatus(I2C_ITPendingBit_TypeDef I2C_ITPendingBit)
;	-----------------------------------------
;	 function I2C_GetITStatus
;	-----------------------------------------
_I2C_GetITStatus:
	sub	sp, #4
;	libstm8s/src/stm8s_i2c.c: 794: __IO uint8_t enablestatus = 0;
	clr	(0x01, sp)
;	libstm8s/src/stm8s_i2c.c: 800: tempregister = (uint8_t)( ((uint16_t)((uint16_t)I2C_ITPendingBit & ITEN_Mask)) >> 8);
	clr	(0x03, sp)
	ld	a, (0x07, sp)
	and	a, #0x07
	ld	xh, a
	clr	a
	clr	a
	ld	xl, a
;	libstm8s/src/stm8s_i2c.c: 803: enablestatus = (uint8_t)(I2C->ITR & ( uint8_t)tempregister);
	ldw	y, #0x521a
	ld	a, (y)
	pushw	x
	and	a, (1, sp)
	popw	x
	ld	(0x01, sp), a
;	libstm8s/src/stm8s_i2c.c: 805: if ((uint16_t)((uint16_t)I2C_ITPendingBit & REGISTER_Mask) == REGISTER_SR1_Index)
	clr	a
	ld	xl, a
	ld	a, (0x07, sp)
	and	a, #0x30
	ld	xh, a
;	libstm8s/src/stm8s_i2c.c: 808: if (((I2C->SR1 & (uint8_t)I2C_ITPendingBit) != RESET) && enablestatus)
	ld	a, (0x08, sp)
	ld	(0x04, sp), a
;	libstm8s/src/stm8s_i2c.c: 805: if ((uint16_t)((uint16_t)I2C_ITPendingBit & REGISTER_Mask) == REGISTER_SR1_Index)
	cpw	x, #0x0100
	jrne	00110$
;	libstm8s/src/stm8s_i2c.c: 808: if (((I2C->SR1 & (uint8_t)I2C_ITPendingBit) != RESET) && enablestatus)
	ldw	x, #0x5217
	ld	a, (x)
	and	a, (0x04, sp)
	tnz	a
	jreq	00102$
	tnz	(0x01, sp)
	jreq	00102$
;	libstm8s/src/stm8s_i2c.c: 811: bitstatus = SET;
	ld	a, #0x01
	jra	00111$
00102$:
;	libstm8s/src/stm8s_i2c.c: 816: bitstatus = RESET;
	clr	a
	jra	00111$
00110$:
;	libstm8s/src/stm8s_i2c.c: 822: if (((I2C->SR2 & (uint8_t)I2C_ITPendingBit) != RESET) && enablestatus)
	ldw	x, #0x5218
	ld	a, (x)
	and	a, (0x04, sp)
	tnz	a
	jreq	00106$
	tnz	(0x01, sp)
	jreq	00106$
;	libstm8s/src/stm8s_i2c.c: 825: bitstatus = SET;
	ld	a, #0x01
;	libstm8s/src/stm8s_i2c.c: 830: bitstatus = RESET;
	.byte 0x21
00106$:
	clr	a
00111$:
;	libstm8s/src/stm8s_i2c.c: 834: return  bitstatus;
	addw	sp, #4
	ret
;	libstm8s/src/stm8s_i2c.c: 871: void I2C_ClearITPendingBit(I2C_ITPendingBit_TypeDef I2C_ITPendingBit)
;	-----------------------------------------
;	 function I2C_ClearITPendingBit
;	-----------------------------------------
_I2C_ClearITPendingBit:
;	libstm8s/src/stm8s_i2c.c: 879: flagpos = (uint16_t)I2C_ITPendingBit & FLAG_Mask;
	ld	a, (0x04, sp)
	ld	xl, a
	clr	a
	ld	xh, a
;	libstm8s/src/stm8s_i2c.c: 882: I2C->SR2 = (uint8_t)((uint16_t)~flagpos);
	cplw	x
	ld	a, xl
	ldw	x, #0x5218
	ld	(x), a
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
