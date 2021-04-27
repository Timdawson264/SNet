#include <stdlib.h>
#include "stm8s_conf.h"
#include "snet.h"
#include "systick.h"

//Main must contain the Decl of the IRQ funcs
void Systick_IRQ(void) __interrupt(23);
void UART1_RX_IRQHandler(void) __interrupt(18);
void UART1_TX_IRQHandler(void) __interrupt(17);

void InitialiseSystemClock()
{
    CLK->ICKR = 0;                       //  Reset the Internal Clock Register.
    CLK->ICKR |= CLK_ICKR_HSIEN;          //  Enable the HSI.
    CLK->ECKR = 0;                       //  Disable the external clock.
    while ((CLK->ICKR & CLK_FLAG_HSIRDY) == 0);       //  Wait for the HSI to be ready for use.
    CLK->CKDIVR = 0;                     //  Ensure the clocks are running at full speed.
    CLK->PCKENR1 = 0xff;                 //  Enable all peripheral clocks.
    CLK->PCKENR2 = 0xff;                 //  Ditto.
    CLK->CCOR = 0;                       //  Turn off CCO.
    CLK->HSITRIMR = 0;                   //  Turn off any HSIU trimming.
    CLK->SWIMCCR = 0;                    //  Set SWIM to run at clock / 2.
    CLK->SWR = 0xe1;                     //  Use HSI as the clock source.
    CLK->SWCR = 0;                       //  Reset the clock switch control register.
    CLK->SWCR = CLK_SWCR_SWEN;                  //  Enable switching.
    while (CLK->SWCR & CLK_SWCR_SWBSY != 0 );        //  Pause while the clock switch is busy.
}

void main()
{   
    disableInterrupts();
	InitialiseSystemClock();
    
    GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_OD_HIZ_FAST);

    systick_init(); //Setup Systicks
    snet_init(); //INIT the network stack

    enableInterrupts();
    
    uint32_t loop_LED = 0;

	while(1)
	{
        uint32_t loop_ms = systick_epoch_ms();
        snet_update();

        if( loop_ms - loop_LED > 500 )
        {
            if( snet_send( "Hello\n", 6, 0xFFFF, false, true, 1 ) )
            {
                //poll this untill send every x ms
                loop_LED = loop_ms; 
                GPIO_WriteReverse( GPIOB, GPIO_PIN_5 );
            }
        }
	}
}


