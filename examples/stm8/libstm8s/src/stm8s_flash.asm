;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Apr  3 2018) (Linux)
; This file was generated Fri Sep 20 09:49:50 2019
;--------------------------------------------------------
	.module stm8s_flash
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _FLASH_Unlock
	.globl _FLASH_Lock
	.globl _FLASH_DeInit
	.globl _FLASH_ITConfig
	.globl _FLASH_EraseByte
	.globl _FLASH_ProgramByte
	.globl _FLASH_ReadByte
	.globl _FLASH_ProgramWord
	.globl _FLASH_ProgramOptionByte
	.globl _FLASH_EraseOptionByte
	.globl _FLASH_ReadOptionByte
	.globl _FLASH_SetLowPowerMode
	.globl _FLASH_SetProgrammingTime
	.globl _FLASH_GetLowPowerMode
	.globl _FLASH_GetProgrammingTime
	.globl _FLASH_GetBootSize
	.globl _FLASH_GetFlagStatus
	.globl _FLASH_WaitForLastOperation
	.globl _FLASH_EraseBlock
	.globl _FLASH_ProgramBlock
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
;	libstm8s/src/stm8s_flash.c: 87: void FLASH_Unlock(FLASH_MemType_TypeDef FLASH_MemType)
;	-----------------------------------------
;	 function FLASH_Unlock
;	-----------------------------------------
_FLASH_Unlock:
;	libstm8s/src/stm8s_flash.c: 93: if(FLASH_MemType == FLASH_MEMTYPE_PROG)
	ld	a, (0x03, sp)
	cp	a, #0xfd
	jrne	00102$
;	libstm8s/src/stm8s_flash.c: 95: FLASH->PUKR = FLASH_RASS_KEY1;
	mov	0x5062+0, #0x56
;	libstm8s/src/stm8s_flash.c: 96: FLASH->PUKR = FLASH_RASS_KEY2;
	mov	0x5062+0, #0xae
	jra	00104$
00102$:
;	libstm8s/src/stm8s_flash.c: 101: FLASH->DUKR = FLASH_RASS_KEY2; /* Warning: keys are reversed on data memory !!! */
	mov	0x5064+0, #0xae
;	libstm8s/src/stm8s_flash.c: 102: FLASH->DUKR = FLASH_RASS_KEY1;
	mov	0x5064+0, #0x56
00104$:
	ret
;	libstm8s/src/stm8s_flash.c: 112: void FLASH_Lock(FLASH_MemType_TypeDef FLASH_MemType)
;	-----------------------------------------
;	 function FLASH_Lock
;	-----------------------------------------
_FLASH_Lock:
;	libstm8s/src/stm8s_flash.c: 118: FLASH->IAPSR &= (uint8_t)FLASH_MemType;
	ldw	x, #0x505f
	ld	a, (x)
	and	a, (0x03, sp)
	ldw	x, #0x505f
	ld	(x), a
	ret
;	libstm8s/src/stm8s_flash.c: 126: void FLASH_DeInit(void)
;	-----------------------------------------
;	 function FLASH_DeInit
;	-----------------------------------------
_FLASH_DeInit:
;	libstm8s/src/stm8s_flash.c: 128: FLASH->CR1 = FLASH_CR1_RESET_VALUE;
	mov	0x505a+0, #0x00
;	libstm8s/src/stm8s_flash.c: 129: FLASH->CR2 = FLASH_CR2_RESET_VALUE;
	mov	0x505b+0, #0x00
;	libstm8s/src/stm8s_flash.c: 130: FLASH->NCR2 = FLASH_NCR2_RESET_VALUE;
	mov	0x505c+0, #0xff
;	libstm8s/src/stm8s_flash.c: 131: FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_DUL);
	ldw	x, #0x505f
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 132: FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_PUL);
	ldw	x, #0x505f
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 133: (void) FLASH->IAPSR; /* Reading of this register causes the clearing of status flags */
	ldw	x, #0x505f
	ld	a, (x)
	ret
;	libstm8s/src/stm8s_flash.c: 142: void FLASH_ITConfig(FunctionalState NewState)
;	-----------------------------------------
;	 function FLASH_ITConfig
;	-----------------------------------------
_FLASH_ITConfig:
;	libstm8s/src/stm8s_flash.c: 147: if(NewState != DISABLE)
	tnz	(0x03, sp)
	jreq	00102$
;	libstm8s/src/stm8s_flash.c: 149: FLASH->CR1 |= FLASH_CR1_IE; /* Enables the interrupt sources */
	ldw	x, #0x505a
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	jra	00104$
00102$:
;	libstm8s/src/stm8s_flash.c: 153: FLASH->CR1 &= (uint8_t)(~FLASH_CR1_IE); /* Disables the interrupt sources */
	ldw	x, #0x505a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
00104$:
	ret
;	libstm8s/src/stm8s_flash.c: 164: void FLASH_EraseByte(uint32_t Address)
;	-----------------------------------------
;	 function FLASH_EraseByte
;	-----------------------------------------
_FLASH_EraseByte:
;	libstm8s/src/stm8s_flash.c: 170: *(PointerAttr uint8_t*) (MemoryAddressCast)Address = FLASH_CLEAR_BYTE;
	ldw	x, (0x05, sp)
	clr	(x)
	ret
;	libstm8s/src/stm8s_flash.c: 181: void FLASH_ProgramByte(uint32_t Address, uint8_t Data)
;	-----------------------------------------
;	 function FLASH_ProgramByte
;	-----------------------------------------
_FLASH_ProgramByte:
;	libstm8s/src/stm8s_flash.c: 185: *(PointerAttr uint8_t*) (MemoryAddressCast)Address = Data;
	ldw	x, (0x05, sp)
	ld	a, (0x07, sp)
	ld	(x), a
	ret
;	libstm8s/src/stm8s_flash.c: 195: uint8_t FLASH_ReadByte(uint32_t Address)
;	-----------------------------------------
;	 function FLASH_ReadByte
;	-----------------------------------------
_FLASH_ReadByte:
;	libstm8s/src/stm8s_flash.c: 201: return(*(PointerAttr uint8_t *) (MemoryAddressCast)Address);
	ldw	x, (0x05, sp)
	ld	a, (x)
	ret
;	libstm8s/src/stm8s_flash.c: 212: void FLASH_ProgramWord(uint32_t Address, uint32_t Data)
;	-----------------------------------------
;	 function FLASH_ProgramWord
;	-----------------------------------------
_FLASH_ProgramWord:
	sub	sp, #4
;	libstm8s/src/stm8s_flash.c: 218: FLASH->CR2 |= FLASH_CR2_WPRG;
	ldw	x, #0x505b
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 219: FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NWPRG);
	ldw	x, #0x505c
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 222: *((PointerAttr uint8_t*)(MemoryAddressCast)Address)       = *((uint8_t*)(&Data));
	ldw	y, (0x09, sp)
	ldw	(0x03, sp), y
	ldw	x, sp
	addw	x, #11
	ldw	(0x01, sp), x
	ldw	x, (0x01, sp)
	ld	a, (x)
	ldw	x, (0x03, sp)
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 224: *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 1) = *((uint8_t*)(&Data)+1);
	ldw	x, (0x03, sp)
	incw	x
	ldw	y, (0x01, sp)
	ld	a, (0x1, y)
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 226: *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 2) = *((uint8_t*)(&Data)+2);
	ldw	x, (0x03, sp)
	incw	x
	incw	x
	ldw	y, (0x01, sp)
	ld	a, (0x2, y)
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 228: *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 3) = *((uint8_t*)(&Data)+3);
	ldw	x, (0x03, sp)
	addw	x, #0x0003
	ldw	y, (0x01, sp)
	ld	a, (0x3, y)
	ld	(x), a
	addw	sp, #4
	ret
;	libstm8s/src/stm8s_flash.c: 237: void FLASH_ProgramOptionByte(uint16_t Address, uint8_t Data)
;	-----------------------------------------
;	 function FLASH_ProgramOptionByte
;	-----------------------------------------
_FLASH_ProgramOptionByte:
;	libstm8s/src/stm8s_flash.c: 243: FLASH->CR2 |= FLASH_CR2_OPT;
	bset	0x505b, #7
;	libstm8s/src/stm8s_flash.c: 244: FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
	ldw	x, #0x505c
	ld	a, (x)
	and	a, #0x7f
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 250: *((NEAR uint8_t*)Address) = Data;
	ldw	x, (0x03, sp)
;	libstm8s/src/stm8s_flash.c: 247: if(Address == 0x4800)
	pushw	x
	ldw	x, (0x05, sp)
	cpw	x, #0x4800
	popw	x
	jrne	00102$
;	libstm8s/src/stm8s_flash.c: 250: *((NEAR uint8_t*)Address) = Data;
	ld	a, (0x05, sp)
	ld	(x), a
	jra	00103$
00102$:
;	libstm8s/src/stm8s_flash.c: 255: *((NEAR uint8_t*)Address) = Data;
	ld	a, (0x05, sp)
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 256: *((NEAR uint8_t*)((uint16_t)(Address + 1))) = (uint8_t)(~Data);
	ldw	x, (0x03, sp)
	incw	x
	ld	a, (0x05, sp)
	cpl	a
	ld	(x), a
00103$:
;	libstm8s/src/stm8s_flash.c: 258: FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
	push	#0xfd
	call	_FLASH_WaitForLastOperation
	pop	a
;	libstm8s/src/stm8s_flash.c: 261: FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
	bres	0x505b, #7
;	libstm8s/src/stm8s_flash.c: 262: FLASH->NCR2 |= FLASH_NCR2_NOPT;
	bset	0x505c, #7
	ret
;	libstm8s/src/stm8s_flash.c: 270: void FLASH_EraseOptionByte(uint16_t Address)
;	-----------------------------------------
;	 function FLASH_EraseOptionByte
;	-----------------------------------------
_FLASH_EraseOptionByte:
;	libstm8s/src/stm8s_flash.c: 276: FLASH->CR2 |= FLASH_CR2_OPT;
	bset	0x505b, #7
;	libstm8s/src/stm8s_flash.c: 277: FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
	ldw	x, #0x505c
	ld	a, (x)
	and	a, #0x7f
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 283: *((NEAR uint8_t*)Address) = FLASH_CLEAR_BYTE;
	ldw	y, (0x03, sp)
;	libstm8s/src/stm8s_flash.c: 280: if(Address == 0x4800)
	ldw	x, (0x03, sp)
	cpw	x, #0x4800
	jrne	00102$
;	libstm8s/src/stm8s_flash.c: 283: *((NEAR uint8_t*)Address) = FLASH_CLEAR_BYTE;
	clr	(y)
	jra	00103$
00102$:
;	libstm8s/src/stm8s_flash.c: 288: *((NEAR uint8_t*)Address) = FLASH_CLEAR_BYTE;
	clr	(y)
;	libstm8s/src/stm8s_flash.c: 289: *((NEAR uint8_t*)((uint16_t)(Address + (uint16_t)1 ))) = FLASH_SET_BYTE;
	ldw	x, (0x03, sp)
	incw	x
	ld	a, #0xff
	ld	(x), a
00103$:
;	libstm8s/src/stm8s_flash.c: 291: FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
	push	#0xfd
	call	_FLASH_WaitForLastOperation
	pop	a
;	libstm8s/src/stm8s_flash.c: 294: FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
	bres	0x505b, #7
;	libstm8s/src/stm8s_flash.c: 295: FLASH->NCR2 |= FLASH_NCR2_NOPT;
	bset	0x505c, #7
	ret
;	libstm8s/src/stm8s_flash.c: 303: uint16_t FLASH_ReadOptionByte(uint16_t Address)
;	-----------------------------------------
;	 function FLASH_ReadOptionByte
;	-----------------------------------------
_FLASH_ReadOptionByte:
	sub	sp, #5
;	libstm8s/src/stm8s_flash.c: 311: value_optbyte = *((NEAR uint8_t*)Address); /* Read option byte */
	ldw	x, (0x08, sp)
	ld	a, (x)
	ld	(0x02, sp), a
;	libstm8s/src/stm8s_flash.c: 312: value_optbyte_complement = *(((NEAR uint8_t*)Address) + 1); /* Read option byte complement */
	ld	a, (0x1, x)
	ld	(0x01, sp), a
;	libstm8s/src/stm8s_flash.c: 317: res_value =	 value_optbyte;
	clrw	x
	ld	a, (0x02, sp)
	ld	xl, a
;	libstm8s/src/stm8s_flash.c: 315: if(Address == 0x4800)
	pushw	x
	ldw	x, (0x0a, sp)
	cpw	x, #0x4800
	popw	x
	jreq	00106$
;	libstm8s/src/stm8s_flash.c: 317: res_value =	 value_optbyte;
	jra	00105$
00105$:
;	libstm8s/src/stm8s_flash.c: 321: if(value_optbyte == (uint8_t)(~value_optbyte_complement))
	ld	a, (0x01, sp)
	cpl	a
	ld	(0x03, sp), a
	ld	a, (0x02, sp)
	cp	a, (0x03, sp)
	jrne	00102$
;	libstm8s/src/stm8s_flash.c: 323: res_value = (uint16_t)((uint16_t)value_optbyte << 8);
	clr	a
	rlwa	x
;	libstm8s/src/stm8s_flash.c: 324: res_value = res_value | (uint16_t)value_optbyte_complement;
	ld	a, (0x01, sp)
	clr	(0x04, sp)
	pushw	x
	or	a, (2, sp)
	popw	x
	rlwa	x
	or	a, (0x04, sp)
	ld	xh, a
	jra	00106$
00102$:
;	libstm8s/src/stm8s_flash.c: 328: res_value = FLASH_OPTIONBYTE_ERROR;
	ldw	x, #0x5555
00106$:
;	libstm8s/src/stm8s_flash.c: 331: return(res_value);
	addw	sp, #5
	ret
;	libstm8s/src/stm8s_flash.c: 340: void FLASH_SetLowPowerMode(FLASH_LPMode_TypeDef FLASH_LPMode)
;	-----------------------------------------
;	 function FLASH_SetLowPowerMode
;	-----------------------------------------
_FLASH_SetLowPowerMode:
;	libstm8s/src/stm8s_flash.c: 346: FLASH->CR1 &= (uint8_t)(~(FLASH_CR1_HALT | FLASH_CR1_AHALT));
	ldw	x, #0x505a
	ld	a, (x)
	and	a, #0xf3
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 349: FLASH->CR1 |= (uint8_t)FLASH_LPMode;
	ldw	x, #0x505a
	ld	a, (x)
	or	a, (0x03, sp)
	ldw	x, #0x505a
	ld	(x), a
	ret
;	libstm8s/src/stm8s_flash.c: 358: void FLASH_SetProgrammingTime(FLASH_ProgramTime_TypeDef FLASH_ProgTime)
;	-----------------------------------------
;	 function FLASH_SetProgrammingTime
;	-----------------------------------------
_FLASH_SetProgrammingTime:
;	libstm8s/src/stm8s_flash.c: 363: FLASH->CR1 &= (uint8_t)(~FLASH_CR1_FIX);
	bres	0x505a, #0
;	libstm8s/src/stm8s_flash.c: 364: FLASH->CR1 |= (uint8_t)FLASH_ProgTime;
	ldw	x, #0x505a
	ld	a, (x)
	or	a, (0x03, sp)
	ldw	x, #0x505a
	ld	(x), a
	ret
;	libstm8s/src/stm8s_flash.c: 372: FLASH_LPMode_TypeDef FLASH_GetLowPowerMode(void)
;	-----------------------------------------
;	 function FLASH_GetLowPowerMode
;	-----------------------------------------
_FLASH_GetLowPowerMode:
;	libstm8s/src/stm8s_flash.c: 374: return((FLASH_LPMode_TypeDef)(FLASH->CR1 & (uint8_t)(FLASH_CR1_HALT | FLASH_CR1_AHALT)));
	ldw	x, #0x505a
	ld	a, (x)
	and	a, #0x0c
	ret
;	libstm8s/src/stm8s_flash.c: 382: FLASH_ProgramTime_TypeDef FLASH_GetProgrammingTime(void)
;	-----------------------------------------
;	 function FLASH_GetProgrammingTime
;	-----------------------------------------
_FLASH_GetProgrammingTime:
;	libstm8s/src/stm8s_flash.c: 384: return((FLASH_ProgramTime_TypeDef)(FLASH->CR1 & FLASH_CR1_FIX));
	ldw	x, #0x505a
	ld	a, (x)
	and	a, #0x01
	ret
;	libstm8s/src/stm8s_flash.c: 392: uint32_t FLASH_GetBootSize(void)
;	-----------------------------------------
;	 function FLASH_GetBootSize
;	-----------------------------------------
_FLASH_GetBootSize:
	sub	sp, #4
;	libstm8s/src/stm8s_flash.c: 397: temp = (uint32_t)((uint32_t)FLASH->FPR * (uint32_t)512);
	ldw	x, #0x505d
	ld	a, (x)
	clrw	x
	ld	xl, a
	clrw	y
	ld	a, #0x09
00109$:
	sllw	x
	rlcw	y
	dec	a
	jrne	00109$
	ldw	(0x03, sp), x
;	libstm8s/src/stm8s_flash.c: 400: if(FLASH->FPR == 0xFF)
	ldw	x, #0x505d
	ld	a, (x)
	cp	a, #0xff
	jrne	00102$
;	libstm8s/src/stm8s_flash.c: 402: temp += 512;
	ldw	x, (0x03, sp)
	addw	x, #0x0200
	ld	a, yl
	adc	a, #0x00
	rlwa	y
	adc	a, #0x00
	ld	yh, a
	ldw	(0x03, sp), x
00102$:
;	libstm8s/src/stm8s_flash.c: 406: return(temp);
	ldw	x, (0x03, sp)
	addw	sp, #4
	ret
;	libstm8s/src/stm8s_flash.c: 417: FlagStatus FLASH_GetFlagStatus(FLASH_Flag_TypeDef FLASH_FLAG)
;	-----------------------------------------
;	 function FLASH_GetFlagStatus
;	-----------------------------------------
_FLASH_GetFlagStatus:
;	libstm8s/src/stm8s_flash.c: 424: if((FLASH->IAPSR & (uint8_t)FLASH_FLAG) != (uint8_t)RESET)
	ldw	x, #0x505f
	ld	a, (x)
	and	a, (0x03, sp)
	tnz	a
	jreq	00102$
;	libstm8s/src/stm8s_flash.c: 426: status = SET; /* FLASH_FLAG is set */
	ld	a, #0x01
;	libstm8s/src/stm8s_flash.c: 430: status = RESET; /* FLASH_FLAG is reset*/
	.byte 0x21
00102$:
	clr	a
00103$:
;	libstm8s/src/stm8s_flash.c: 434: return status;
	ret
;	libstm8s/src/stm8s_flash.c: 549: IN_RAM(FLASH_Status_TypeDef FLASH_WaitForLastOperation(FLASH_MemType_TypeDef FLASH_MemType))
;	-----------------------------------------
;	 function FLASH_WaitForLastOperation
;	-----------------------------------------
_FLASH_WaitForLastOperation:
;	libstm8s/src/stm8s_flash.c: 551: uint8_t flagstatus = 0x00;
	clr	a
;	libstm8s/src/stm8s_flash.c: 577: while((flagstatus == 0x00) && (timeout != 0x00))
	ldw	x, #0xffff
00102$:
	tnz	a
	jrne	00104$
	tnzw	x
	jreq	00104$
;	libstm8s/src/stm8s_flash.c: 579: flagstatus = (uint8_t)(FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS));
	ldw	y, #0x505f
	ld	a, (y)
	and	a, #0x05
;	libstm8s/src/stm8s_flash.c: 580: timeout--;
	decw	x
	jra	00102$
00104$:
;	libstm8s/src/stm8s_flash.c: 584: if(timeout == 0x00 )
	tnzw	x
	jrne	00106$
;	libstm8s/src/stm8s_flash.c: 586: flagstatus = FLASH_STATUS_TIMEOUT;
	ld	a, #0x02
00106$:
;	libstm8s/src/stm8s_flash.c: 589: return((FLASH_Status_TypeDef)flagstatus);
	ret
;	libstm8s/src/stm8s_flash.c: 599: IN_RAM(void FLASH_EraseBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType))
;	-----------------------------------------
;	 function FLASH_EraseBlock
;	-----------------------------------------
_FLASH_EraseBlock:
	sub	sp, #6
;	libstm8s/src/stm8s_flash.c: 612: if(FLASH_MemType == FLASH_MEMTYPE_PROG)
	ld	a, (0x0b, sp)
	cp	a, #0xfd
	jrne	00102$
;	libstm8s/src/stm8s_flash.c: 615: startaddress = FLASH_PROG_START_PHYSICAL_ADDRESS;
	ldw	x, #0x8000
	ldw	(0x05, sp), x
	clrw	x
	ldw	(0x03, sp), x
	jra	00103$
00102$:
;	libstm8s/src/stm8s_flash.c: 620: startaddress = FLASH_DATA_START_PHYSICAL_ADDRESS;
	ldw	x, #0x4000
	ldw	(0x05, sp), x
	clrw	x
	ldw	(0x03, sp), x
00103$:
;	libstm8s/src/stm8s_flash.c: 628: pwFlash = (PointerAttr uint32_t *)(MemoryAddressCast)(startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE));
	ldw	y, (0x09, sp)
	clrw	x
	ld	a, #0x06
00113$:
	sllw	y
	rlcw	x
	dec	a
	jrne	00113$
	addw	y, (0x05, sp)
	ld	a, xl
	adc	a, (0x04, sp)
	rlwa	x
	adc	a, (0x03, sp)
	ldw	(0x01, sp), y
;	libstm8s/src/stm8s_flash.c: 632: FLASH->CR2 |= FLASH_CR2_ERASE;
	ldw	x, #0x505b
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 633: FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NERASE);
	ldw	x, #0x505c
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 637: *pwFlash = (uint32_t)0;
	ldw	x, (0x01, sp)
	clrw	y
	ldw	(0x2, x), y
	ldw	(x), y
	addw	sp, #6
	ret
;	libstm8s/src/stm8s_flash.c: 656: IN_RAM(void FLASH_ProgramBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType,
;	-----------------------------------------
;	 function FLASH_ProgramBlock
;	-----------------------------------------
_FLASH_ProgramBlock:
	sub	sp, #14
;	libstm8s/src/stm8s_flash.c: 665: if(FLASH_MemType == FLASH_MEMTYPE_PROG)
	ld	a, (0x13, sp)
	cp	a, #0xfd
	jrne	00102$
;	libstm8s/src/stm8s_flash.c: 668: startaddress = FLASH_PROG_START_PHYSICAL_ADDRESS;
	ldw	x, #0x8000
	ldw	(0x09, sp), x
	clr	a
	clr	(0x07, sp)
	jra	00103$
00102$:
;	libstm8s/src/stm8s_flash.c: 673: startaddress = FLASH_DATA_START_PHYSICAL_ADDRESS;
	ldw	x, #0x4000
	ldw	(0x09, sp), x
	clr	a
	clr	(0x07, sp)
00103$:
;	libstm8s/src/stm8s_flash.c: 677: startaddress = startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE);
	ldw	y, (0x11, sp)
	clrw	x
	push	a
	ld	a, #0x06
00128$:
	sllw	y
	rlcw	x
	dec	a
	jrne	00128$
	ldw	(0x0c, sp), x
	pop	a
	addw	y, (0x09, sp)
	adc	a, (0x0c, sp)
	ld	xl, a
	ld	a, (0x07, sp)
	adc	a, (0x0b, sp)
	ld	xh, a
	ldw	(0x03, sp), y
	ldw	(0x01, sp), x
;	libstm8s/src/stm8s_flash.c: 680: if(FLASH_ProgMode == FLASH_PROGRAMMODE_STANDARD)
	tnz	(0x14, sp)
	jrne	00105$
;	libstm8s/src/stm8s_flash.c: 683: FLASH->CR2 |= FLASH_CR2_PRG;
	bset	0x505b, #0
;	libstm8s/src/stm8s_flash.c: 684: FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NPRG);
	ldw	x, #0x505c
	ld	a, (x)
	and	a, #0xfe
	ld	(x), a
	jra	00114$
00105$:
;	libstm8s/src/stm8s_flash.c: 689: FLASH->CR2 |= FLASH_CR2_FPRG;
	ldw	x, #0x505b
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 690: FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NFPRG);
	ldw	x, #0x505c
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	libstm8s/src/stm8s_flash.c: 694: for(Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
00114$:
	clrw	x
	ldw	(0x05, sp), x
00108$:
;	libstm8s/src/stm8s_flash.c: 696: *((PointerAttr uint8_t*) (MemoryAddressCast)startaddress + Count) = ((uint8_t)(Buffer[Count]));
	ldw	y, (0x03, sp)
	addw	y, (0x05, sp)
	ldw	x, (0x15, sp)
	addw	x, (0x05, sp)
	ld	a, (x)
	ld	(y), a
;	libstm8s/src/stm8s_flash.c: 694: for(Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
	ldw	x, (0x05, sp)
	incw	x
	ldw	(0x05, sp), x
	ldw	x, (0x05, sp)
	cpw	x, #0x0040
	jrc	00108$
	addw	sp, #14
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
