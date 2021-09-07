#ifndef SNET_HAL_H__
#define SNET_HAL_H__

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/** Bus symbol rate in bits-per-second. */
#define SNET_HAL_BAUDRATE (50000)

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
 * Checks the current status of the transmitter.
 *
 * @returns @c TRUE if the hardware is busy transmitting.
 */
bool
snet_hal_is_transmitting(void);


/**
 * Sets the bus direction based on our current state. @see snet_hal_direction_t.
 *
 * @param direction the direction to configure our bus into.
 */
void
snet_hal_set_direction(snet_hal_direction_t direction);

/**
 * Implemented by the HAL layer return a systick type monotonic clock
 * 
 * @note can be called from IRQ ctx should return microseconds. 
 * @returns microseconds since boot.
 */
uint32_t 
snet_hal_get_ticks();


/**
 * Caclculates a crc32 using builtin hardware if avalible
 * not required to be implemeted
 *
 * @param Data the Data to checksum
 * @param Length the number of octects of data
 * @returns @c The CRC32
 */
//~ uint32_t
//~ snet_hal_calc_crc32( uint8_t* data, uint16_t length ) __attribute__((weak, alias("snet_crc32_bitwise"))) ;

/**
 * Data structer that holds data and length info.
 * used to pass multiple buffers to the TX
 */
typedef struct iovec_t
{
	uint8_t* data;
	uint8_t length;
} iovec_t;


#endif
