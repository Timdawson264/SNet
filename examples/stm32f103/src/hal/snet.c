#include "snet.h"
#include "stm32f1xx_hal.h"


#define RX_ENABLE_PIN (GPIO_PIN_11)
#define TX_ENABLE_PIN (GPIO_PIN_12)


static UART_HandleTypeDef huart;


void
snet_hal_init(void)
{
    GPIO_InitTypeDef gpio;

    /* Direction pins. */
    gpio.Pin = GPIO_PIN_11 | GPIO_PIN_12;
    gpio.Mode = GPIO_MODE_OUTPUT_PP;
    gpio.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOA, &gpio);

    snet_hal_set_direction(SNET_HAL_DIR_IDLE);

    /* UART peripheral. */
    huart.Instance = USART1;
    huart.Init.BaudRate = SNET_HAL_BAUDRATE;
    huart.Init.WordLength = UART_WORDLENGTH_8B;
    huart.Init.StopBits = UART_STOPBITS_1;
    huart.Init.Parity = UART_PARITY_NONE;
    huart.Init.Mode = UART_MODE_TX_RX;
    huart.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    huart.Init.OverSampling = UART_OVERSAMPLING_16;
    HAL_UART_Init(&huart);

    /* Configure our receive interrupt. */
    __HAL_UART_ENABLE_IT(&huart, UART_IT_RXNE);
}


void
snet_hal_transmit(iovec_t *vec, uint8_t number)
{
    uint16_t i,v;

	for (v = 0; v < number; v++)
	{
		uint8_t* data = vec[v].data;
		uint16_t length = vec[v].length;
		
		for (i = 0; i < length; i++)
		{
			while (!(huart.Instance->SR & UART_FLAG_TXE))
				;

			huart.Instance->DR = data[i];
		}
	}
}


bool
snet_hal_is_transmitting(void)
{
    return !(huart.Instance->SR & UART_FLAG_TXE);
}


void
snet_hal_set_direction(snet_hal_direction_t direction)
{
    switch (direction)
    {
    case SNET_HAL_DIR_IDLE:
        HAL_GPIO_WritePin(GPIOA, RX_ENABLE_PIN, GPIO_PIN_SET);
        HAL_GPIO_WritePin(GPIOA, TX_ENABLE_PIN, GPIO_PIN_RESET);
        break;

    case SNET_HAL_DIR_TX:
        HAL_GPIO_WritePin(GPIOA, RX_ENABLE_PIN, GPIO_PIN_SET);
        HAL_GPIO_WritePin(GPIOA, TX_ENABLE_PIN, GPIO_PIN_SET);
        break;

    case SNET_HAL_DIR_RX:
        HAL_GPIO_WritePin(GPIOA, RX_ENABLE_PIN, GPIO_PIN_RESET);
        HAL_GPIO_WritePin(GPIOA, TX_ENABLE_PIN, GPIO_PIN_RESET);
        break;
    }
}


void
USART1_IRQHandler(void)
{
    if (__HAL_UART_GET_FLAG(&huart, UART_FLAG_RXNE))
    {
        uint8_t ch = huart.Instance->DR;
        snet_hal_receive(&ch, 1);
    }
}
