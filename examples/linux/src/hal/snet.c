#include "snet_hal.h"

#include <pthread.h>
#include <time.h>
#include <libserialport.h>
#include <stdio.h>
#include <stdlib.h>

struct sp_port* serial_port;

static char *serial_name = "/dev/ttyUSB0";

void *rx_thread(void *vargp)
{
    printf("RX started\n");

    char read_buf [256]; //RX buf
    while (1)
    {
        int num_bytes = sp_blocking_read_next(serial_port, read_buf, 256, 0 );
        if ( num_bytes > 0 )
        {
            snet_hal_receive((uint8_t*)read_buf, num_bytes); //pass to snet stack
        }

    }

    return NULL;
}


//Create RX Thread - aka irq ctx.
void
snet_hal_init()
{
    if( sp_get_port_by_name(serial_name, &serial_port) != SP_OK ) exit(1);
    if( sp_open( serial_port, SP_MODE_READ_WRITE ) != SP_OK ) exit(1);
    if( sp_set_baudrate(serial_port, SNET_HAL_BAUDRATE) != SP_OK ) exit(1);
    if( sp_set_bits(serial_port, 8) != SP_OK ) exit(1);
    if( sp_set_parity(serial_port, SP_PARITY_NONE) != SP_OK ) exit(1);
    if( sp_set_stopbits(serial_port, 1) != SP_OK ) exit(1);
    if( sp_set_flowcontrol(serial_port, SP_FLOWCONTROL_NONE) != SP_OK ) exit(1);

    //start RX thread
    pthread_t thread;
    pthread_create(&thread, NULL, rx_thread, NULL);
}

void
snet_hal_transmit(uint8_t *data, uint16_t length)
{
    enum sp_return r;
    r = sp_blocking_write(serial_port, data, length, 1000);
    if( r<0 )
    {
        exit(1);
    }
}

bool
snet_hal_is_transmitting()
{
    int r = sp_output_waiting(serial_port);
    if( r<0 )
        exit(1);

    return (r>0);
}

void
snet_hal_set_direction(snet_hal_direction_t direction)
{
    switch( direction )
	{
        case SNET_HAL_DIR_IDLE:
		case SNET_HAL_DIR_RX:
            if( sp_set_dtr(serial_port, SP_DTR_ON) != SP_OK )
                exit(2);
            break;
        case SNET_HAL_DIR_TX:
            if( sp_set_dtr(serial_port, SP_DTR_OFF) != SP_OK )
                exit(2);
            break;
        }
}

uint32_t 
snet_hal_get_ticks()
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time );

    uint32_t milli = (time.tv_sec * 1000) + (time.tv_nsec / 1e6);
    return milli;
}

void debug_putc(char c)
{
    fputc(c, stderr);
}