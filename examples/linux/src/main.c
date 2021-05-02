#include <stdlib.h>
#include "snet.h"
#include <unistd.h>
#include <stdio.h>

#include "snet_hal.h"


int main()
{   
    snet_init(); //INIT the network stack
    
    uint32_t loop_LED = 0;

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
