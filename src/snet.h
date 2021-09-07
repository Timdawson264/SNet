#ifndef SNET_H__
#define SNET_H__

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>

#include "printf.h"
#include "snet_hal.h"

typedef uint16_t snet_addr_t;

/**
 * Initialises the SNet library. This must be called before any other library
 * functions.
 */
void
snet_init(void);


/**
 * Gives processing time to SNet. This function must be called periodically.
 */
void
snet_update(void);


/**
 * Implemented within SNet to allow the HAL layer to pass received data up.
 *
 * @note this may be called from an interrupt context. Received data wont be
 * processed until @ref snet_update() is called.
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
 * Implemented within SNet to allow the HAL layer to pass received data up.
 *
 * @note this may be called from an interrupt context. Received data wont be
 * processed until @ref snet_update() is called.
 *
 * @param data the received octet.
 *
 * @returns the number of octets copied into @ref data.
 */
void
snet_hal_receive_byte(uint8_t data);

/**
 * Transmits data on the bus.
 *
 * @param data the data to send.
 * @param length the number of octets to send.
 * @param dst_addr The Destination node address
 * @param req_ack should the packet be acknowledged by dst node
 * @param crc enable crc32 over data.
 */
bool
snet_send(  uint8_t* data,
            uint16_t length, 
            snet_addr_t dst_addr, 
            bool req_ack, 
            bool crc, 
            uint8_t priority
        );

#endif
