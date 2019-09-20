#include "snet.h"

#include <string.h>

#define SNET_DEBUG
#include "snet_internal.h"


static ringbuf_t rx_rb;
static uint8_t rx_buf[256];

static bool transmitting;


void
snet_init(void)
{
    DEBUG("init\n");

    ringbuf_init(&rx_rb, rx_buf, sizeof(rx_buf));

    snet_hal_init();
    snet_hal_set_direction(SNET_HAL_DIR_IDLE);
}


void
snet_update(void)
{
    uint8_t ch;

    /* Handle transmit completion. */
    if (!snet_hal_is_transmitting() && transmitting)
    {
        snet_hal_set_direction(SNET_HAL_DIR_RX);
        transmitting = false;
    }

    /* Process any received data. */
    while (ringbuf_pop(&rx_rb, &ch))
    {
        DEBUG("%02x\n", ch);
    }
}


void
snet_send(uint8_t *data, uint16_t length)
{
    snet_hal_set_direction(SNET_HAL_DIR_TX);
    snet_hal_transmit(data, length);
    transmitting = true;
}


void
snet_hal_receive(uint8_t *data, uint16_t length)
{
    int i;

    for (i = 0; i < length; i++)
    {
        ringbuf_push(&rx_rb, data[i]);
    }
}
