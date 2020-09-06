
#include <stdlib.h>
#include "stm8s_conf.h"
#include "snet_hal.h"
#include "systick.h"

void snet_hal_init(void)
{
    UART1_DeInit();
	UART1_Init( SNET_HAL_BAUDRATE, 
                UART1_WORDLENGTH_8D, 
                UART1_STOPBITS_1, 
                UART1_PARITY_NO, 
                UART1_SYNCMODE_CLOCK_DISABLE, 
                UART1_MODE_TXRX_ENABLE
            );
    //enable RX IRQ
    UART1_ITConfig( UART1_IT_RXNE , ENABLE );
    //UART1_ITConfig( UART1_IT_TXE , ENABLE );
    //UART1_ITConfig( UART1_IT_TC , ENABLE );
    //UART1_ITConfig( UART1_IT_IDLE, ENABLE );

    //setup GPIO
    GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_SLOW );
}

void snet_hal_transmit(uint8_t *data, uint16_t length)
{
    while( length-- )
    {
        UART1->DR = *data++;
        while( ( UART1->SR & UART1_SR_TXE ) == 0);
    }
}

bool snet_hal_is_transmitting(void)
{
    if( ( UART1->SR & ( UART1_SR_TXE | UART1_SR_TC ) ) == 0 )
    {   
        return true;
    }
    else
    {
        return false;
    }
}

void snet_hal_set_direction(snet_hal_direction_t direction)
{
    switch( direction )
	{
        case SNET_HAL_DIR_IDLE:
		case SNET_HAL_DIR_RX:
            GPIO_WriteLow(GPIOD,GPIO_PIN_4);
            break;
        case SNET_HAL_DIR_TX:
            GPIO_WriteHigh(GPIOD,GPIO_PIN_4);
            break;
    }
}

uint32_t snet_hal_get_ticks()
{
    return systick_epoch_us();
}

void UART1_TX_IRQHandler(void) __interrupt(17)
{

}

void UART1_RX_IRQHandler(void) __interrupt(18)
{
    snet_hal_receive_byte( UART1_ReceiveData8() );
}
