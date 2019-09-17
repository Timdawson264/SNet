#ifndef SNET_HAL_H__
#define SNET_HAL_H__

#include <stdint.h>


/** Bus symbol rate in bits-per-second. */
#define SNET_HAL_BAUDRATE (9600)


/**
 * The different states the bus can be in hardware.
 */
typedef enum snet_hal_direction_t
{
    /** Bus is not being used at all - could be power saving. */
    SNET_HAL_DIR_IDLE,

    /** Bus is ready for data to be sent. */
    SNET_HAL_DIR_TX,

    /** Bus is ready to receive data. */
    SNET_HAL_DIR_RX
} snet_hal_direction_t;


/**
 * Initialises the HAL for use. This will be called before any other HAL
 * functions.
 */
void
snet_hal_init(void);


/**
 * Implemented by the HAL layer to send data onto the bus.
 *
 * @note The HAL layer should assume the bus is ready to go and send
 * immediately.
 *
 * @param data the buffer to transmit.
 * @param length the number of octets to send.
 */
void
snet_hal_transmit(uint8_t *data, uint16_t length);


/**
 * Implemented within SNet to allow the HAL layer to pass received data up.
 *
 * @note it is assumed the data pointer will only be valid for the duration of
 * this function call. I.e. the caller may free the data once this function has
 * returned.
 *
 * @param data the buffer with the received data.
 * @param length the number of octets received.
 *
 * @returns the number of octets copied into @ref data.
 */
void
snet_hal_receive(uint8_t *data, uint16_t length);


/**
 * Sets the bus direction based on our current state. @see snet_hal_direction_t.
 *
 * @param direction the direction to configure our bus into.
 */
void
snet_hal_set_direction(snet_hal_direction_t direction);


/* TODO: We'll probably want a means to schedule a hardware timer interrupt. */


#endif
