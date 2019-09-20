#ifndef SNET_H__
#define SNET_H__

#include <stdint.h>
#include <stdbool.h>

#include "printf.h"
#include "snet_hal.h"


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
 * Transmits data on the bus.
 *
 * @param data the data to send.
 * @param length the number of octets to send.
 */
void
snet_send(uint8_t *data, uint16_t length);


#endif
