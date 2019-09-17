#include <stdint.h>

#include "stm8s_conf.h"

void InitialiseSystemClock()
{
    CLK->ICKR = 0;                       //  Reset the Internal Clock Register.
    CLK->ICKR |= CLK_ICKR_HSIEN;          //  Enable the HSI.
    CLK->ECKR = 0;                       //  Disable the external clock.
    while (CLK->ICKR & CLK_FLAG_HSIRDY == 0);       //  Wait for the HSI to be ready for use.
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

void delay()
{

	uint16_t c = 0;
        uint16_t i = 0;
	for( i=0; i<10; i++)
		while( --c ) nop();
}


void main()
{

	InitialiseSystemClock();
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_OD_HIZ_SLOW);

	while(1)
	{
		delay();
		GPIO_WriteReverse(GPIOB,GPIO_PIN_5);
	}

}
