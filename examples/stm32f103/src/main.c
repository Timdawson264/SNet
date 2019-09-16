#include "stm32f1xx_hal.h"

/* TODO: Think about a tidy way to make this work. It's located in the
 * autogenerated cube stuff, but we need to have our own declaration. */
void SystemClock_Config(void);


int
main(void)
{
    HAL_Init();
    SystemClock_Config();

    __HAL_RCC_GPIOC_CLK_ENABLE();

    /* Configure our LED. */
    GPIO_InitTypeDef gpio;

    gpio.Pin = GPIO_PIN_13;
    gpio.Mode = GPIO_MODE_OUTPUT_PP;
    gpio.Pull = GPIO_NOPULL;
    gpio.Speed = GPIO_SPEED_FREQ_LOW;

    HAL_GPIO_Init(GPIOC, &gpio);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);

    while (1)
    {
        HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);
        HAL_Delay(200);
    }
}


void
SysTick_Handler(void)
{
    HAL_IncTick();
}
