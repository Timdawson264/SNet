#include <stdlib.h>
#include "snet.h"
#include <unistd.h>
#include <stdio.h>

int main()
{   
    snet_init(); //INIT the network stack
    
    uint32_t loop_LED = 0;

    char* string = "WORLD\n";

    usleep((1e6));

    snet_hal_set_direction(SNET_HAL_DIR_TX);
    snet_hal_transmit( (uint8_t*) string, 6 );
    //usleep(100);
    snet_hal_is_transmitting();
    snet_hal_set_direction(SNET_HAL_DIR_RX);
    fprintf(stderr, "TX done\n");
    usleep(1e6);

    exit(1);

    while (1)
    {
        usleep(10000);

        uint32_t loop_ms = snet_hal_get_ticks();
        snet_update();

        if( loop_ms - loop_LED > 500 )
        {
            if( snet_send( (uint8_t*) "Test\n", 5, 0xFFFF, false, false, 1 ) )
            {
                //poll this untill send every x ms
                loop_LED = loop_ms;
                printf("Send pkt\n");
            }
        }
	}

    return 0;
}
