#include "snet.h"

#include <string.h>

#define SNET_DEBUG
#include "snet_internal.h"


static uint8_t rx_buf[256];

static snet_stack_ctx stack_ctx;


void
snet_init(void)
{
    DEBUG("init\n");

    ringbuf_init(&stack_ctx.rx_rb, rx_buf, sizeof(rx_buf));

    snet_hal_init();
    snet_hal_set_direction(SNET_HAL_DIR_IDLE);
}


void
snet_update(void)
{
    uint8_t ch;

    /* Handle transmit completion. */
    if (!snet_hal_is_transmitting() && stack_ctx.tx_state == SNET_TX_TRANSMITTING )
    {
        snet_hal_set_direction(SNET_HAL_DIR_RX);
        //TODO check ACKREQ in TX_PKT
        stack_ctx.tx_state = SNET_TX_IDLE;
    }

    /* Process any received data. */
    while (ringbuf_pop(&stack_ctx.rx_rb, &ch))
    {
        DEBUG("%02x\n", ch);
    }
}


void
snet_send(uint8_t *data, uint16_t length)
{
    snet_hal_set_direction(SNET_HAL_DIR_TX);
    snet_hal_transmit(data, length);
    //TODO: This state transition should be in the _update func
    stack_ctx.tx_state = SNET_TX_TRANSMITTING;
}


void
snet_hal_receive(uint8_t *data, uint16_t length)
{
    int i;

    for (i = 0; i < length; i++)
    {
        ringbuf_push(&stack_ctx.rx_rb, data[i]);
    }
}
