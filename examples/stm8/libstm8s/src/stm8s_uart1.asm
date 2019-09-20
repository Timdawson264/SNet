;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Apr  3 2018) (Linux)
; This file was generated Fri Sep 20 09:49:49 2019
;--------------------------------------------------------
	.module stm8s_uart1
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _CLK_GetClockFreq
	.globl _UART1_DeInit
	.globl _UART1_Init
	.globl _UART1_Cmd
	.globl _UART1_ITConfig
	.globl _UART1_HalfDuplexCmd
	.globl _UART1_IrDAConfig
	.globl _UART1_IrDACmd
	.globl _UART1_LINBreakDetectionConfig
	.globl _UART1_LINCmd
	.globl _UART1_SmartCardCmd
	.globl _UART1_SmartCardNACKCmd
	.globl _UART1_WakeUpConfig
	.globl _UART1_ReceiverWakeUpCmd
	.globl _UART1_ReceiveData8
	.globl _UART1_ReceiveData9
	.globl _UART1_SendData8
	.globl _UART1_SendData9
	.globl _UART1_SendBreak
	.globl _UART1_SetAddress
	.globl _UART1_SetGuardTime
	.globl _UART1_SetPrescaler
	.globl _UART1_GetFlagStatus
	.globl _UART1_ClearFlag
	.globl _UART1_GetITStatus
	.globl _UART1_ClearITPendingBit
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
;	libstm8s/src/stm8s_uart1.c: 53: void UART1_DeInit(void)
;	-----------------------------------------
;	 function UART1_DeInit
;	-----------------------------------------
_UART1_DeInit:
;	libstm8s/src/stm8s_uart1.c: 57: (void)UART1->SR;
	ldw	x, #0x5230
	ld	a, (x)
;	libstm8s/src/stm8s_uart1.c: 58: (void)UART1->DR;
	ldw	x, #0x5231
	ld	a, (x)
;	libstm8s/src/stm8s_uart1.c: 60: UART1->BRR2 = UART1_BRR2_RESET_VALUE;  /* Set UART1_BRR2 to reset value 0x00 */
	mov	0x5233+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 61: UART1->BRR1 = UART1_BRR1_RESET_VALUE;  /* Set UART1_BRR1 to reset value 0x00 */
	mov	0x5232+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 63: UART1->CR1 = UART1_CR1_RESET_VALUE;  /* Set UART1_CR1 to reset value 0x00 */
	mov	0x5234+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 64: UART1->CR2 = UART1_CR2_RESET_VALUE;  /* Set UART1_CR2 to reset value 0x00 */
	mov	0x5235+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 65: UART1->CR3 = UART1_CR3_RESET_VALUE;  /* Set UART1_CR3 to reset value 0x00 */
	mov	0x5236+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 66: UART1->CR4 = UART1_CR4_RESET_VALUE;  /* Set UART1_CR4 to reset value 0x00 */
	mov	0x5237+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 67: UART1->CR5 = UART1_CR5_RESET_VALUE;  /* Set UART1_CR5 to reset value 0x00 */
	mov	0x5238+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 69: UART1->GTR = UART1_GTR_RESET_VALUE;
	mov	0x5239+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 70: UART1->PSCR = UART1_PSCR_RESET_VALUE;
	mov	0x523a+0, #0x00
	ret
;	libstm8s/src/stm8s_uart1.c: 90: void UART1_Init(uint32_t BaudRate, UART1_WordLength_TypeDef WordLength, 
;	-----------------------------------------
;	 function UART1_Init
;	-----------------------------------------
_UART1_Init:
	sub	sp, #33
;	libstm8s/src/stm8s_uart1.c: 105: UART1->CR1 &= (uint8_t)(~UART1_CR1_M);  
	ldw	x, #0x5234
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 108: UART1->CR1 |= (uint8_t)WordLength;
	ldw	x, #0x5234
	ld	a, (x)
	or	a, (0x28, sp)
	ldw	x, #0x5234
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 111: UART1->CR3 &= (uint8_t)(~UART1_CR3_STOP);  
	ldw	x, #0x5236
	ld	a, (x)
	and	a, #0xcf
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 113: UART1->CR3 |= (uint8_t)StopBits;  
	ldw	x, #0x5236
	ld	a, (x)
	or	a, (0x29, sp)
	ldw	x, #0x5236
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 116: UART1->CR1 &= (uint8_t)(~(UART1_CR1_PCEN | UART1_CR1_PS  ));  
	ldw	x, #0x5234
	ld	a, (x)
	and	a, #0xf9
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 118: UART1->CR1 |= (uint8_t)Parity;  
	ldw	x, #0x5234
	ld	a, (x)
	or	a, (0x2a, sp)
	ldw	x, #0x5234
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 121: UART1->BRR1 &= (uint8_t)(~UART1_BRR1_DIVM);  
	ldw	x, #0x5232
	ld	a, (x)
	mov	0x5232+0, #0x00
;	libstm8s/src/stm8s_uart1.c: 123: UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVM);  
	ldw	x, #0x5233
	ld	a, (x)
	and	a, #0x0f
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 125: UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVF);  
	ldw	x, #0x5233
	ld	a, (x)
	and	a, #0xf0
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 128: BaudRate_Mantissa    = ((uint32_t)CLK_GetClockFreq() / (BaudRate << 4));
	call	_CLK_GetClockFreq
	ldw	(0x0b, sp), x
	ldw	x, (0x24, sp)
	ldw	(0x1d, sp), x
	ldw	x, (0x26, sp)
	ld	a, #0x04
00124$:
	sllw	x
	rlc	(0x1e, sp)
	rlc	(0x1d, sp)
	dec	a
	jrne	00124$
	ldw	(0x1f, sp), x
	ldw	x, (0x1f, sp)
	pushw	x
	ldw	x, (0x1f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	pushw	y
	call	__divulong
	addw	sp, #8
	ldw	(0x03, sp), x
	ldw	(0x01, sp), y
;	libstm8s/src/stm8s_uart1.c: 129: BaudRate_Mantissa100 = (((uint32_t)CLK_GetClockFreq() * 100) / (BaudRate << 4));
	call	_CLK_GetClockFreq
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	pushw	y
	push	#0x64
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	ldw	(0x1b, sp), x
	ldw	x, (0x1f, sp)
	pushw	x
	ldw	x, (0x1f, sp)
	pushw	x
	ldw	x, (0x1f, sp)
	pushw	x
	pushw	y
	call	__divulong
	addw	sp, #8
	ldw	(0x07, sp), x
	ldw	(0x05, sp), y
;	libstm8s/src/stm8s_uart1.c: 131: UART1->BRR2 |= (uint8_t)((uint8_t)(((BaudRate_Mantissa100 - (BaudRate_Mantissa * 100)) << 4) / 100) & (uint8_t)0x0F); 
	ldw	x, #0x5233
	ld	a, (x)
	ld	(0x18, sp), a
	ldw	x, (0x03, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	push	#0x64
	clrw	x
	pushw	x
	push	#0x00
	call	__mullong
	addw	sp, #8
	ldw	(0x16, sp), x
	ldw	(0x14, sp), y
	ldw	x, (0x07, sp)
	subw	x, (0x16, sp)
	ldw	(0x12, sp), x
	ld	a, (0x06, sp)
	sbc	a, (0x15, sp)
	ld	(0x11, sp), a
	ld	a, (0x05, sp)
	sbc	a, (0x14, sp)
	ld	(0x10, sp), a
	ldw	y, (0x12, sp)
	ldw	x, (0x10, sp)
	ld	a, #0x04
00126$:
	sllw	y
	rlcw	x
	dec	a
	jrne	00126$
	push	#0x64
	push	#0x00
	push	#0x00
	push	#0x00
	pushw	y
	pushw	x
	call	__divulong
	addw	sp, #8
	ld	a, xl
	and	a, #0x0f
	or	a, (0x18, sp)
	ldw	x, #0x5233
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 133: UART1->BRR2 |= (uint8_t)((BaudRate_Mantissa >> 4) & (uint8_t)0xF0); 
	ldw	x, #0x5233
	ld	a, (x)
	ld	(0x0f, sp), a
	ldw	x, (0x03, sp)
	ldw	y, (0x01, sp)
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	ld	a, xl
	and	a, #0xf0
	ld	xl, a
	clr	a
	clrw	y
	ld	a, xl
	or	a, (0x0f, sp)
	ldw	x, #0x5233
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 135: UART1->BRR1 |= (uint8_t)BaudRate_Mantissa;           
	ldw	x, #0x5232
	ld	a, (x)
	ld	(0x0e, sp), a
	ld	a, (0x04, sp)
	or	a, (0x0e, sp)
	ldw	x, #0x5232
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 138: UART1->CR2 &= (uint8_t)~(UART1_CR2_TEN | UART1_CR2_REN); 
	ldw	x, #0x5235
	ld	a, (x)
	and	a, #0xf3
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 140: UART1->CR3 &= (uint8_t)~(UART1_CR3_CPOL | UART1_CR3_CPHA | UART1_CR3_LBCL); 
	ldw	x, #0x5236
	ld	a, (x)
	and	a, #0xf8
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 142: UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & (uint8_t)(UART1_CR3_CPOL | 
	ldw	x, #0x5236
	ld	a, (x)
	ld	(0x0d, sp), a
	ld	a, (0x2b, sp)
	and	a, #0x07
	or	a, (0x0d, sp)
	ldw	x, #0x5236
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 145: if ((uint8_t)(Mode & UART1_MODE_TX_ENABLE))
	ld	a, (0x2c, sp)
	bcp	a, #0x04
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 148: UART1->CR2 |= (uint8_t)UART1_CR2_TEN;  
	ldw	x, #0x5235
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	jra	00103$
00102$:
;	libstm8s/src/stm8s_uart1.c: 153: UART1->CR2 &= (uint8_t)(~UART1_CR2_TEN);  
	ldw	x, #0x5235
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
00103$:
;	libstm8s/src/stm8s_uart1.c: 155: if ((uint8_t)(Mode & UART1_MODE_RX_ENABLE))
	ld	a, (0x2c, sp)
	bcp	a, #0x08
	jreq	00105$
;	libstm8s/src/stm8s_uart1.c: 158: UART1->CR2 |= (uint8_t)UART1_CR2_REN;  
	ldw	x, #0x5235
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	jra	00106$
00105$:
;	libstm8s/src/stm8s_uart1.c: 163: UART1->CR2 &= (uint8_t)(~UART1_CR2_REN);  
	ldw	x, #0x5235
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
00106$:
;	libstm8s/src/stm8s_uart1.c: 167: if ((uint8_t)(SyncMode & UART1_SYNCMODE_CLOCK_DISABLE))
	tnz	(0x2b, sp)
	jrpl	00108$
;	libstm8s/src/stm8s_uart1.c: 170: UART1->CR3 &= (uint8_t)(~UART1_CR3_CKEN); 
	ldw	x, #0x5236
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	jra	00110$
00108$:
;	libstm8s/src/stm8s_uart1.c: 174: UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & UART1_CR3_CKEN);
	ldw	x, #0x5236
	ld	a, (x)
	ld	(0x21, sp), a
	ld	a, (0x2b, sp)
	and	a, #0x08
	or	a, (0x21, sp)
	ldw	x, #0x5236
	ld	(x), a
00110$:
	addw	sp, #33
	ret
;	libstm8s/src/stm8s_uart1.c: 184: void UART1_Cmd(FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_Cmd
;	-----------------------------------------
_UART1_Cmd:
;	libstm8s/src/stm8s_uart1.c: 186: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 189: UART1->CR1 &= (uint8_t)(~UART1_CR1_UARTD); 
	ldw	x, #0x5234
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 194: UART1->CR1 |= UART1_CR1_UARTD;  
	ldw	x, #0x5234
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 211: void UART1_ITConfig(UART1_IT_TypeDef UART1_IT, FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_ITConfig
;	-----------------------------------------
_UART1_ITConfig:
	sub	sp, #3
;	libstm8s/src/stm8s_uart1.c: 220: uartreg = (uint8_t)((uint16_t)UART1_IT >> 0x08);
	ld	a, (0x06, sp)
	ld	xh, a
	clr	a
;	libstm8s/src/stm8s_uart1.c: 222: itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
	ld	a, (0x07, sp)
	and	a, #0x0f
	ld	xl, a
	ld	a, #0x01
	push	a
	ld	a, xl
	tnz	a
	jreq	00139$
00138$:
	sll	(1, sp)
	dec	a
	jrne	00138$
00139$:
	pop	a
	ld	(0x01, sp), a
;	libstm8s/src/stm8s_uart1.c: 227: if (uartreg == 0x01)
	ld	a, xh
	cp	a, #0x01
	jrne	00141$
	ld	a, #0x01
	ld	(0x03, sp), a
	jra	00142$
00141$:
	clr	(0x03, sp)
00142$:
;	libstm8s/src/stm8s_uart1.c: 231: else if (uartreg == 0x02)
	ld	a, xh
	cp	a, #0x02
	jrne	00144$
	ld	a, #0x01
	.byte 0x21
00144$:
	clr	a
00145$:
;	libstm8s/src/stm8s_uart1.c: 224: if (NewState != DISABLE)
	tnz	(0x08, sp)
	jreq	00114$
;	libstm8s/src/stm8s_uart1.c: 227: if (uartreg == 0x01)
	tnz	(0x03, sp)
	jreq	00105$
;	libstm8s/src/stm8s_uart1.c: 229: UART1->CR1 |= itpos;
	ldw	x, #0x5234
	ld	a, (x)
	or	a, (0x01, sp)
	ldw	x, #0x5234
	ld	(x), a
	jra	00116$
00105$:
;	libstm8s/src/stm8s_uart1.c: 231: else if (uartreg == 0x02)
	tnz	a
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 233: UART1->CR2 |= itpos;
	ldw	x, #0x5235
	ld	a, (x)
	or	a, (0x01, sp)
	ldw	x, #0x5235
	ld	(x), a
	jra	00116$
00102$:
;	libstm8s/src/stm8s_uart1.c: 237: UART1->CR4 |= itpos;
	ldw	x, #0x5237
	ld	a, (x)
	or	a, (0x01, sp)
	ldw	x, #0x5237
	ld	(x), a
	jra	00116$
00114$:
;	libstm8s/src/stm8s_uart1.c: 245: UART1->CR1 &= (uint8_t)(~itpos);
	push	a
	ld	a, (0x02, sp)
	cpl	a
	ld	(0x03, sp), a
	pop	a
;	libstm8s/src/stm8s_uart1.c: 243: if (uartreg == 0x01)
	tnz	(0x03, sp)
	jreq	00111$
;	libstm8s/src/stm8s_uart1.c: 245: UART1->CR1 &= (uint8_t)(~itpos);
	ldw	x, #0x5234
	ld	a, (x)
	and	a, (0x02, sp)
	ldw	x, #0x5234
	ld	(x), a
	jra	00116$
00111$:
;	libstm8s/src/stm8s_uart1.c: 247: else if (uartreg == 0x02)
	tnz	a
	jreq	00108$
;	libstm8s/src/stm8s_uart1.c: 249: UART1->CR2 &= (uint8_t)(~itpos);
	ldw	x, #0x5235
	ld	a, (x)
	and	a, (0x02, sp)
	ldw	x, #0x5235
	ld	(x), a
	jra	00116$
00108$:
;	libstm8s/src/stm8s_uart1.c: 253: UART1->CR4 &= (uint8_t)(~itpos);
	ldw	x, #0x5237
	ld	a, (x)
	and	a, (0x02, sp)
	ldw	x, #0x5237
	ld	(x), a
00116$:
	addw	sp, #3
	ret
;	libstm8s/src/stm8s_uart1.c: 265: void UART1_HalfDuplexCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_HalfDuplexCmd
;	-----------------------------------------
_UART1_HalfDuplexCmd:
;	libstm8s/src/stm8s_uart1.c: 269: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 271: UART1->CR5 |= UART1_CR5_HDSEL;  /**< UART1 Half Duplex Enable  */
	ldw	x, #0x5238
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 275: UART1->CR5 &= (uint8_t)~UART1_CR5_HDSEL; /**< UART1 Half Duplex Disable */
	ldw	x, #0x5238
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 285: void UART1_IrDAConfig(UART1_IrDAMode_TypeDef UART1_IrDAMode)
;	-----------------------------------------
;	 function UART1_IrDAConfig
;	-----------------------------------------
_UART1_IrDAConfig:
;	libstm8s/src/stm8s_uart1.c: 289: if (UART1_IrDAMode != UART1_IRDAMODE_NORMAL)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 291: UART1->CR5 |= UART1_CR5_IRLP;
	ldw	x, #0x5238
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 295: UART1->CR5 &= ((uint8_t)~UART1_CR5_IRLP);
	ldw	x, #0x5238
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 305: void UART1_IrDACmd(FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_IrDACmd
;	-----------------------------------------
_UART1_IrDACmd:
;	libstm8s/src/stm8s_uart1.c: 310: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 313: UART1->CR5 |= UART1_CR5_IREN;
	ldw	x, #0x5238
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 318: UART1->CR5 &= ((uint8_t)~UART1_CR5_IREN);
	ldw	x, #0x5238
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 329: void UART1_LINBreakDetectionConfig(UART1_LINBreakDetectionLength_TypeDef UART1_LINBreakDetectionLength)
;	-----------------------------------------
;	 function UART1_LINBreakDetectionConfig
;	-----------------------------------------
_UART1_LINBreakDetectionConfig:
;	libstm8s/src/stm8s_uart1.c: 333: if (UART1_LINBreakDetectionLength != UART1_LINBREAKDETECTIONLENGTH_10BITS)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 335: UART1->CR4 |= UART1_CR4_LBDL;
	ldw	x, #0x5237
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 339: UART1->CR4 &= ((uint8_t)~UART1_CR4_LBDL);
	ldw	x, #0x5237
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 349: void UART1_LINCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_LINCmd
;	-----------------------------------------
_UART1_LINCmd:
;	libstm8s/src/stm8s_uart1.c: 353: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 356: UART1->CR3 |= UART1_CR3_LINEN;
	ldw	x, #0x5236
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 361: UART1->CR3 &= ((uint8_t)~UART1_CR3_LINEN);
	ldw	x, #0x5236
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 371: void UART1_SmartCardCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_SmartCardCmd
;	-----------------------------------------
_UART1_SmartCardCmd:
;	libstm8s/src/stm8s_uart1.c: 375: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 378: UART1->CR5 |= UART1_CR5_SCEN;
	ldw	x, #0x5238
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 383: UART1->CR5 &= ((uint8_t)(~UART1_CR5_SCEN));
	ldw	x, #0x5238
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 394: void UART1_SmartCardNACKCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_SmartCardNACKCmd
;	-----------------------------------------
_UART1_SmartCardNACKCmd:
;	libstm8s/src/stm8s_uart1.c: 398: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 401: UART1->CR5 |= UART1_CR5_NACK;
	ldw	x, #0x5238
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 406: UART1->CR5 &= ((uint8_t)~(UART1_CR5_NACK));
	ldw	x, #0x5238
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 416: void UART1_WakeUpConfig(UART1_WakeUp_TypeDef UART1_WakeUp)
;	-----------------------------------------
;	 function UART1_WakeUpConfig
;	-----------------------------------------
_UART1_WakeUpConfig:
;	libstm8s/src/stm8s_uart1.c: 420: UART1->CR1 &= ((uint8_t)~UART1_CR1_WAKE);
	ldw	x, #0x5234
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 421: UART1->CR1 |= (uint8_t)UART1_WakeUp;
	ldw	x, #0x5234
	ld	a, (x)
	or	a, (0x03, sp)
	ldw	x, #0x5234
	ld	(x), a
	ret
;	libstm8s/src/stm8s_uart1.c: 430: void UART1_ReceiverWakeUpCmd(FunctionalState NewState)
;	-----------------------------------------
;	 function UART1_ReceiverWakeUpCmd
;	-----------------------------------------
_UART1_ReceiverWakeUpCmd:
;	libstm8s/src/stm8s_uart1.c: 434: if (NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 437: UART1->CR2 |= UART1_CR2_RWU;
	ldw	x, #0x5235
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 442: UART1->CR2 &= ((uint8_t)~UART1_CR2_RWU);
	ldw	x, #0x5235
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 451: uint8_t UART1_ReceiveData8(void)
;	-----------------------------------------
;	 function UART1_ReceiveData8
;	-----------------------------------------
_UART1_ReceiveData8:
;	libstm8s/src/stm8s_uart1.c: 453: return ((uint8_t)UART1->DR);
	ldw	x, #0x5231
	ld	a, (x)
	ret
;	libstm8s/src/stm8s_uart1.c: 461: uint16_t UART1_ReceiveData9(void)
;	-----------------------------------------
;	 function UART1_ReceiveData9
;	-----------------------------------------
_UART1_ReceiveData9:
	sub	sp, #4
;	libstm8s/src/stm8s_uart1.c: 465: temp = (uint16_t)(((uint16_t)( (uint16_t)UART1->CR1 & (uint16_t)UART1_CR1_R8)) << 1);
	ldw	x, #0x5234
	ld	a, (x)
	clr	(0x03, sp)
	and	a, #0x80
	ld	xl, a
	clr	a
	ld	xh, a
	sllw	x
	ldw	(0x01, sp), x
;	libstm8s/src/stm8s_uart1.c: 466: return (uint16_t)( (((uint16_t) UART1->DR) | temp ) & ((uint16_t)0x01FF));
	ldw	x, #0x5231
	ld	a, (x)
	clrw	x
	ld	xl, a
	or	a, (0x02, sp)
	rlwa	x
	or	a, (0x01, sp)
	and	a, #0x01
	ld	xh, a
	addw	sp, #4
	ret
;	libstm8s/src/stm8s_uart1.c: 474: void UART1_SendData8(uint8_t Data)
;	-----------------------------------------
;	 function UART1_SendData8
;	-----------------------------------------
_UART1_SendData8:
;	libstm8s/src/stm8s_uart1.c: 477: UART1->DR = Data;
	ldw	x, #0x5231
	ld	a, (0x03, sp)
	ld	(x), a
	ret
;	libstm8s/src/stm8s_uart1.c: 486: void UART1_SendData9(uint16_t Data)
;	-----------------------------------------
;	 function UART1_SendData9
;	-----------------------------------------
_UART1_SendData9:
	push	a
;	libstm8s/src/stm8s_uart1.c: 489: UART1->CR1 &= ((uint8_t)~UART1_CR1_T8);
	ldw	x, #0x5234
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 491: UART1->CR1 |= (uint8_t)(((uint8_t)(Data >> 2)) & UART1_CR1_T8);
	ldw	x, #0x5234
	ld	a, (x)
	ld	(0x01, sp), a
	ldw	x, (0x04, sp)
	srlw	x
	srlw	x
	ld	a, xl
	and	a, #0x40
	or	a, (0x01, sp)
	ldw	x, #0x5234
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 493: UART1->DR   = (uint8_t)(Data);
	ld	a, (0x05, sp)
	ldw	x, #0x5231
	ld	(x), a
	pop	a
	ret
;	libstm8s/src/stm8s_uart1.c: 501: void UART1_SendBreak(void)
;	-----------------------------------------
;	 function UART1_SendBreak
;	-----------------------------------------
_UART1_SendBreak:
;	libstm8s/src/stm8s_uart1.c: 503: UART1->CR2 |= UART1_CR2_SBK;
	bset	0x5235, #0
	ret
;	libstm8s/src/stm8s_uart1.c: 511: void UART1_SetAddress(uint8_t UART1_Address)
;	-----------------------------------------
;	 function UART1_SetAddress
;	-----------------------------------------
_UART1_SetAddress:
;	libstm8s/src/stm8s_uart1.c: 517: UART1->CR4 &= ((uint8_t)~UART1_CR4_ADD);
	ldw	x, #0x5237
	ld	a, (x)
	and	a, #0xf0
	ld	(x), a
;	libstm8s/src/stm8s_uart1.c: 519: UART1->CR4 |= UART1_Address;
	ldw	x, #0x5237
	ld	a, (x)
	or	a, (0x03, sp)
	ldw	x, #0x5237
	ld	(x), a
	ret
;	libstm8s/src/stm8s_uart1.c: 528: void UART1_SetGuardTime(uint8_t UART1_GuardTime)
;	-----------------------------------------
;	 function UART1_SetGuardTime
;	-----------------------------------------
_UART1_SetGuardTime:
;	libstm8s/src/stm8s_uart1.c: 531: UART1->GTR = UART1_GuardTime;
	ldw	x, #0x5239
	ld	a, (0x03, sp)
	ld	(x), a
	ret
;	libstm8s/src/stm8s_uart1.c: 556: void UART1_SetPrescaler(uint8_t UART1_Prescaler)
;	-----------------------------------------
;	 function UART1_SetPrescaler
;	-----------------------------------------
_UART1_SetPrescaler:
;	libstm8s/src/stm8s_uart1.c: 559: UART1->PSCR = UART1_Prescaler;
	ldw	x, #0x523a
	ld	a, (0x03, sp)
	ld	(x), a
	ret
;	libstm8s/src/stm8s_uart1.c: 568: FlagStatus UART1_GetFlagStatus(UART1_Flag_TypeDef UART1_FLAG)
;	-----------------------------------------
;	 function UART1_GetFlagStatus
;	-----------------------------------------
_UART1_GetFlagStatus:
	push	a
;	libstm8s/src/stm8s_uart1.c: 579: if ((UART1->CR4 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
	ld	a, (0x05, sp)
	ld	(0x01, sp), a
;	libstm8s/src/stm8s_uart1.c: 577: if (UART1_FLAG == UART1_FLAG_LBDF)
	ldw	x, (0x04, sp)
	cpw	x, #0x0210
	jrne	00114$
;	libstm8s/src/stm8s_uart1.c: 579: if ((UART1->CR4 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
	ldw	x, #0x5237
	ld	a, (x)
	and	a, (0x01, sp)
	tnz	a
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 582: status = SET;
	ld	a, #0x01
	jra	00115$
00102$:
;	libstm8s/src/stm8s_uart1.c: 587: status = RESET;
	clr	a
	jra	00115$
00114$:
;	libstm8s/src/stm8s_uart1.c: 590: else if (UART1_FLAG == UART1_FLAG_SBK)
	ldw	x, (0x04, sp)
	cpw	x, #0x0101
	jrne	00111$
;	libstm8s/src/stm8s_uart1.c: 592: if ((UART1->CR2 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
	ldw	x, #0x5235
	ld	a, (x)
	and	a, (0x01, sp)
	tnz	a
	jreq	00105$
;	libstm8s/src/stm8s_uart1.c: 595: status = SET;
	ld	a, #0x01
	jra	00115$
00105$:
;	libstm8s/src/stm8s_uart1.c: 600: status = RESET;
	clr	a
	jra	00115$
00111$:
;	libstm8s/src/stm8s_uart1.c: 605: if ((UART1->SR & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
	ldw	x, #0x5230
	ld	a, (x)
	and	a, (0x01, sp)
	tnz	a
	jreq	00108$
;	libstm8s/src/stm8s_uart1.c: 608: status = SET;
	ld	a, #0x01
;	libstm8s/src/stm8s_uart1.c: 613: status = RESET;
	.byte 0x21
00108$:
	clr	a
00115$:
;	libstm8s/src/stm8s_uart1.c: 617: return status;
	addw	sp, #1
	ret
;	libstm8s/src/stm8s_uart1.c: 646: void UART1_ClearFlag(UART1_Flag_TypeDef UART1_FLAG)
;	-----------------------------------------
;	 function UART1_ClearFlag
;	-----------------------------------------
_UART1_ClearFlag:
;	libstm8s/src/stm8s_uart1.c: 651: if (UART1_FLAG == UART1_FLAG_RXNE)
	ldw	x, (0x03, sp)
	cpw	x, #0x0020
	jrne	00102$
;	libstm8s/src/stm8s_uart1.c: 653: UART1->SR = (uint8_t)~(UART1_SR_RXNE);
	mov	0x5230+0, #0xdf
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 658: UART1->CR4 &= (uint8_t)~(UART1_CR4_LBDF);
	ldw	x, #0x5237
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_uart1.c: 675: ITStatus UART1_GetITStatus(UART1_IT_TypeDef UART1_IT)
;	-----------------------------------------
;	 function UART1_GetITStatus
;	-----------------------------------------
_UART1_GetITStatus:
	sub	sp, #5
;	libstm8s/src/stm8s_uart1.c: 687: itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
	ld	a, (0x09, sp)
	ld	xh, a
	and	a, #0x0f
	ld	xl, a
	ld	a, #0x01
	push	a
	ld	a, xl
	tnz	a
	jreq	00154$
00153$:
	sll	(1, sp)
	dec	a
	jrne	00153$
00154$:
	pop	a
	ld	(0x03, sp), a
;	libstm8s/src/stm8s_uart1.c: 689: itmask1 = (uint8_t)((uint8_t)UART1_IT >> (uint8_t)4);
	rlwa	x
	swap	a
	and	a, #0x0f
	rrwa	x
;	libstm8s/src/stm8s_uart1.c: 691: itmask2 = (uint8_t)((uint8_t)1 << itmask1);
	ld	a, #0x01
	push	a
	ld	a, xh
	tnz	a
	jreq	00156$
00155$:
	sll	(1, sp)
	dec	a
	jrne	00155$
00156$:
	pop	a
	ld	(0x02, sp), a
;	libstm8s/src/stm8s_uart1.c: 695: if (UART1_IT == UART1_IT_PE)
	ldw	x, (0x08, sp)
	cpw	x, #0x0100
	jrne	00117$
;	libstm8s/src/stm8s_uart1.c: 698: enablestatus = (uint8_t)((uint8_t)UART1->CR1 & itmask2);
	ldw	x, #0x5234
	ld	a, (x)
	and	a, (0x02, sp)
	ld	(0x05, sp), a
;	libstm8s/src/stm8s_uart1.c: 701: if (((UART1->SR & itpos) != (uint8_t)0x00) && enablestatus)
	ldw	x, #0x5230
	ld	a, (x)
	and	a, (0x03, sp)
	tnz	a
	jreq	00102$
	tnz	(0x05, sp)
	jreq	00102$
;	libstm8s/src/stm8s_uart1.c: 704: pendingbitstatus = SET;
	ld	a, #0x01
	jra	00118$
00102$:
;	libstm8s/src/stm8s_uart1.c: 709: pendingbitstatus = RESET;
	clr	a
	jra	00118$
00117$:
;	libstm8s/src/stm8s_uart1.c: 713: else if (UART1_IT == UART1_IT_LBDF)
	ldw	x, (0x08, sp)
	cpw	x, #0x0346
	jrne	00114$
;	libstm8s/src/stm8s_uart1.c: 716: enablestatus = (uint8_t)((uint8_t)UART1->CR4 & itmask2);
	ldw	x, #0x5237
	ld	a, (x)
	and	a, (0x02, sp)
	ld	(0x01, sp), a
;	libstm8s/src/stm8s_uart1.c: 718: if (((UART1->CR4 & itpos) != (uint8_t)0x00) && enablestatus)
	ldw	x, #0x5237
	ld	a, (x)
	and	a, (0x03, sp)
	tnz	a
	jreq	00106$
	tnz	(0x01, sp)
	jreq	00106$
;	libstm8s/src/stm8s_uart1.c: 721: pendingbitstatus = SET;
	ld	a, #0x01
	jra	00118$
00106$:
;	libstm8s/src/stm8s_uart1.c: 726: pendingbitstatus = RESET;
	clr	a
	jra	00118$
00114$:
;	libstm8s/src/stm8s_uart1.c: 732: enablestatus = (uint8_t)((uint8_t)UART1->CR2 & itmask2);
	ldw	x, #0x5235
	ld	a, (x)
	and	a, (0x02, sp)
	ld	(0x04, sp), a
;	libstm8s/src/stm8s_uart1.c: 734: if (((UART1->SR & itpos) != (uint8_t)0x00) && enablestatus)
	ldw	x, #0x5230
	ld	a, (x)
	and	a, (0x03, sp)
	tnz	a
	jreq	00110$
	tnz	(0x04, sp)
	jreq	00110$
;	libstm8s/src/stm8s_uart1.c: 737: pendingbitstatus = SET;
	ld	a, #0x01
;	libstm8s/src/stm8s_uart1.c: 742: pendingbitstatus = RESET;
	.byte 0x21
00110$:
	clr	a
00118$:
;	libstm8s/src/stm8s_uart1.c: 747: return  pendingbitstatus;
	addw	sp, #5
	ret
;	libstm8s/src/stm8s_uart1.c: 775: void UART1_ClearITPendingBit(UART1_IT_TypeDef UART1_IT)
;	-----------------------------------------
;	 function UART1_ClearITPendingBit
;	-----------------------------------------
_UART1_ClearITPendingBit:
;	libstm8s/src/stm8s_uart1.c: 780: if (UART1_IT == UART1_IT_RXNE)
	ldw	x, (0x03, sp)
	cpw	x, #0x0255
	jrne	00102$
;	libstm8s/src/stm8s_uart1.c: 782: UART1->SR = (uint8_t)~(UART1_SR_RXNE);
	mov	0x5230+0, #0xdf
	jra	00104$
00102$:
;	libstm8s/src/stm8s_uart1.c: 787: UART1->CR4 &= (uint8_t)~(UART1_CR4_LBDF);
	ldw	x, #0x5237
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
00104$:
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
