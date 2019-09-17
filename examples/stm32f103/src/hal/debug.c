#include <stdbool.h>

#include "stm32f1xx_hal.h"
#include "printf.h"


static UART_HandleTypeDef huart;
static bool initialised = false;


static void
debug_init(void)
{
    huart.Instance = USART2;
    huart.Init.BaudRate = 115200;
    huart.Init.WordLength = UART_WORDLENGTH_8B;
    huart.Init.StopBits = UART_STOPBITS_1;
    huart.Init.Parity = UART_PARITY_NONE;
    huart.Init.Mode = UART_MODE_TX;
    huart.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    huart.Init.OverSampling = UART_OVERSAMPLING_16;
    HAL_UART_Init(&huart);

    initialised = true;
}


void
debug_putc(char ch)
{
    if (!initialised)
        debug_init();

    while (!(huart.Instance->SR & UART_FLAG_TXE))
        ;

    huart.Instance->DR = ch;
}
