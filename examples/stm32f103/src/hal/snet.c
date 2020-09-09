#include "snet_hal.h"
#include "stm32f1xx_hal.h"


#define TXRX_ENABLE_PIN (GPIO_PIN_8)
//#define TX_ENABLE_PIN (GPIO_PIN_12)


static UART_HandleTypeDef huart;


void
snet_hal_init(void)
{
    GPIO_InitTypeDef gpio;

    /* Direction pins. */
    //gpio.Pin = GPIO_PIN_11 | GPIO_PIN_12;
    gpio.Pin = TXRX_ENABLE_PIN;
    gpio.Mode = GPIO_MODE_OUTPUT_PP;
    gpio.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOA, &gpio);

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
snet_hal_transmit(uint8_t *data, uint16_t length)
{
    uint16_t i;

    for (i = 0; i < length; i++)
    {
        //Make sure DR is empty before writing to it.
        while( (  huart.Instance->SR & UART_FLAG_TXE ) == 0);
        huart.Instance->DR = data[i];
    }
}

bool
snet_hal_is_transmitting(void)
{
    return ( ( huart.Instance->SR & UART_FLAG_TC ) == 0 );
}

void
snet_hal_set_direction(snet_hal_direction_t direction)
{
    switch (direction)
    {
    case SNET_HAL_DIR_TX:
        //HAL_GPIO_WritePin(GPIOA, RX_ENABLE_PIN, GPIO_PIN_SET);
        HAL_GPIO_WritePin(GPIOA, TXRX_ENABLE_PIN, GPIO_PIN_SET);
        break;

    case SNET_HAL_DIR_IDLE:
        //HAL_GPIO_WritePin(GPIOA, RX_ENABLE_PIN, GPIO_PIN_SET);
        //HAL_GPIO_WritePin(GPIOA, TX_ENABLE_PIN, GPIO_PIN_RESET);
        //break;
    case SNET_HAL_DIR_RX:
        //HAL_GPIO_WritePin(GPIOA, RX_ENABLE_PIN, GPIO_PIN_RESET);
        HAL_GPIO_WritePin(GPIOA, TXRX_ENABLE_PIN, GPIO_PIN_RESET);
        break;
    }
}

uint32_t
snet_hal_get_ticks()
{
    return HAL_GetTick();
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
