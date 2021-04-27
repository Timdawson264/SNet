#include "snet_hal.h"

#include <pthread.h>
#include <time.h>

#include <fcntl.h> // Contains file controls like O_RDWR
#include <errno.h> // Error integer and strerror() function
#include <termios.h> // Contains POSIX terminal control definitions
#include <unistd.h> // write(), read(), close()
#include <stdio.h>
#include <string.h>

static int serial_FD = -1;
static char *serial_file = "/dev/ttyUSB0";

void *rx_thread(void *vargp)
{
    printf("RX started\n");

    char read_buf [256]; //RX buf
    while (1)
    {
        int num_bytes = read(serial_FD, &read_buf, sizeof(read_buf));
        if( num_bytes )
            snet_hal_receive((uint8_t*)read_buf, num_bytes); //pass to snet stack

    }

    return NULL;
}


//Create RX Thread - aka irq ctx.
void
snet_hal_init()
{
    //todo: make pthread - open fd
    serial_FD = open(serial_file, O_RDWR | O_SYNC);

    if (serial_FD < 0) {
     fprintf(stderr, "Error %i from open: %s\n", errno, strerror(errno));
    }

    struct termios tty;
    if(tcgetattr(serial_FD, &tty) != 0) {
        fprintf(stderr, "Error %i from tcgetattr: %s\n", errno, strerror(errno));
    }
    tty.c_cflag = CS8;
    //Disable char escaping and buffering
    tty.c_lflag &= ~ICANON;
    tty.c_lflag &= ~ECHO; // Disable echo
    tty.c_lflag &= ~ECHOE; // Disable erasure
    tty.c_lflag &= ~ECHONL; // Disable new-line echo
    tty.c_lflag &= ~ISIG; // Disable interpretation of INTR, QUIT and SUSP
    tty.c_iflag &= ~(IXON | IXOFF | IXANY); // Turn off s/w flow ctrl
    tty.c_iflag &= ~(IGNBRK|BRKINT|PARMRK|ISTRIP|INLCR|IGNCR|ICRNL); // Disable any special handling of received bytes
    tty.c_oflag &= ~OPOST; // Prevent special interpretation of output bytes (e.g. newline chars)
    tty.c_oflag &= ~ONLCR; // Prevent conversion of newline to carriage return/line feed

    tty.c_cc[VTIME] = 10;    // Wait for up to 1s (10 deciseconds), returning as soon as any data is received.
    tty.c_cc[VMIN] = 0;

    cfsetispeed(&tty, B500000);
    cfsetospeed(&tty, B500000);

    //start RX thread
    pthread_t thread;
    pthread_create(&thread, NULL, rx_thread, NULL);
}

void
snet_hal_transmit(uint8_t *data, uint16_t length)
{
    ssize_t s = write( serial_FD , data, length);
    if( s < 0 )
    {
        fprintf(stderr, "Error %i from write: %s\n", errno, strerror(errno));
    }
    if( s != length )
    {
        fprintf(stderr, "Error writing to serial port: %d\n", s);
    }
}

bool
snet_hal_is_transmitting()
{
    //writes are syncrounouse O_SYNC
    return false;
}

void
snet_hal_set_direction(snet_hal_direction_t direction)
{
    switch( direction )
	{
        case SNET_HAL_DIR_IDLE:
		case SNET_HAL_DIR_RX:
            //TODO: Workout what needs doing

            break;
        case SNET_HAL_DIR_TX:
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