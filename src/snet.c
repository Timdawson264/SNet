#include "snet.h"

#define SNET_DEBUG
#include "snet_internal.h"


void
snet_init(void)
{
    DEBUG("init\n");
    snet_hal_init();
    snet_hal_set_direction(SNET_HAL_DIR_IDLE);
}
