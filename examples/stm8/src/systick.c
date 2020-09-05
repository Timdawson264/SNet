#include "systick.h"

static uint32_t systick_ovf_counter = 0;

// 16Mhz / 128 = 125000hz  into timer
#define F_CLK ( 16000000ul )
#define T_CLK ( F_CLK / 128 )
#define FT_RATIO ( 1000000ul / T_CLK ) 

void systick_init(void)
{
    TIM4_DeInit(); //Disable TIM4
    //Set Prescaler and Auto Reload value
    TIM4_TimeBaseInit(  TIM4_PRESCALER_128, 0xFF );
    TIM4_ITConfig( TIM4_IT_UPDATE, ENABLE ); //Enable IRQ
	systick_ovf_counter = 0;
    TIM4_Cmd( ENABLE ); //Start TIM4	
}

//On Each overflow we record that this happened
//We are using the Timer + Over flow as the Tick counter
void Systick_IRQ(void) __interrupt(23)
 {
    TIM4->SR1 &=~ 0x01; //Clear IT flag
    systick_ovf_counter+=0x100;  //The timer just counted 0xff
	//GPIO_WriteReverse(GPIOB,GPIO_PIN_5);
	//GPIO_WriteHigh( GPIOB, GPIO_PIN_5 );
 }

// 1Mhz Ticks. aka 1us
uint32_t 
systick_ticks_us(void)
{
	uint32_t m;
	uint8_t f;

	//do a double read
	do {
		m = systick_ovf_counter;		    //read the overflow counter
		f = TIM4->CNTR;						//read the least significant 8-bits
	} while (m != systick_ovf_counter);		//gaurd against overflow

	return (m | f) << 3; //*FT_RATIO
}

uint32_t 
systick_epoch_ms(void) 
{
    return systick_ticks_us() / 1000;
}

void 
systick_delayms(uint32_t ms) 
{
	uint32_t start_time = systick_ticks_us();

	ms *= 1000; //convert ms to us
	while (systick_ticks_us() - start_time < ms) continue;	//wait for timer to expire
}

void 
systick_delayus(uint32_t us) 
{
	uint32_t start_time = systick_ticks_us();
	while (systick_ticks_us() - start_time < us) continue;	//wait for timer to expire
}