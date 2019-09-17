#include "snet.h"

#define SNET_DEBUG
#include "snet_internal.h"


static uint8_t rxbuf[256];
static uint16_t buflen;


void
snet_init(void)
{
    DEBUG("init\n");

    buflen = 0;

    snet_hal_init();
    snet_hal_set_direction(SNET_HAL_DIR_IDLE);
}


void
snet_hal_receive(uint8_t *data, uint16_t length)
{
    int i;

    for (i = 0; i < length; i++)
    {
        rxbuf[buflen] = data[i];
        buflen = (buflen + 1) % sizeof(rxbuf);
    }

#ifdef SNET_DEBUG
    if (buflen >= 16)
    {
        DEBUG("Received:\n >  ");
        for (int i = 0; i < buflen; i++)
        {
            if (i % 8 == 0 && i != 0 && i != buflen - 1)
                printf("\n >  ");

            printf("%02x", rxbuf[i]);
        }
        printf("\n");
        buflen = 0;
    }
#endif
}
