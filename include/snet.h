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


#endif
