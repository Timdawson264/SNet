#ifndef RINGBUF_H__
#define RINGBUF_H__

#include <stdint.h>
#include <stdbool.h>


typedef struct ringbuf_t
{
    uint16_t read_ptr;
    uint16_t write_ptr;
    uint8_t *data;
    uint16_t capacity;
} ringbuf_t;


void
ringbuf_init(ringbuf_t *rb, uint8_t *buffer, uint16_t capacity);


bool
ringbuf_empty(ringbuf_t *rb);


bool
ringbuf_full(ringbuf_t *rb);


bool
rinbuf_push(ringbuf_t *rb, uint8_t octet);


bool
ringbuf_pop(ringbuf_t *rb, uint8_t *octet);


#endif
