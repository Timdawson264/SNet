#ifndef RINGBUF_H__
#define RINGBUF_H__

#include <stdint.h>
#include <stdbool.h>


/**
 * Ring buffer structure. This structure should not be modified externally.
 */
typedef struct ringbuf_t
{
    /** Pointer to the next octet that may be read. */
    uint16_t read_ptr;

    /** Pointer to the next free spot where data may be written. */
    uint16_t write_ptr;

    /** The memory backing the ring buffer. */
    uint8_t *data;

    /** The maximum number of octets that may be written to the ring buffer. */
    uint16_t capacity;
} ringbuf_t;


/**
 * Initialises a new ring buffer for use.
 *
 * @param rb the ring buffer to initialise.
 * @param buffer the memory backing the ring buffer.
 * @param capacity the maximum number of octets that may be stored
 *                 in the buffer.
 */
void
ringbuf_init(ringbuf_t *rb, uint8_t *buffer, uint16_t capacity);


/**
 * Checks if there is any data in the ring buffer.
 *
 * @returns @c TRUE if there is no data in the ring buffer.
 */
bool
ringbuf_empty(ringbuf_t *rb);


/**
 * Checks if there is any free space in the ring buffer.
 *
 * @returns @c TRUE if the ring buffer is full.
 */
bool
ringbuf_full(ringbuf_t *rb);


/**
 * Adds an octet into the ring buffer.
 *
 * @param rb the ring buffer to add into.
 * @param octet the data to be added.
 *
 * @returns @c TRUE if the octet was successfully added.
 */
bool
ringbuf_push(ringbuf_t *rb, uint8_t octet);


/**
 * Removes an octet from the ring buffer.
 *
 * @param rb the ring buffer to remove from.
 * @param octet pointer to somewhere a single octet can be copied to.
 *
 * @returns @c TRUE if an octet was successfully removed from the buffer.
 */
bool
ringbuf_pop(ringbuf_t *rb, uint8_t *octet);


#endif
