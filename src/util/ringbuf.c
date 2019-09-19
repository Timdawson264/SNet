#include "ringbuf.h"


void
ringbuf_init(ringbuf_t *rb, uint8_t *buffer, uint16_t capacity)
{
    rb->read_ptr = 0;
    rb->write_ptr = 0;
    rb->data = buffer;
    rb->capacity = capacity;
}


bool
ringbuf_empty(ringbuf_t *rb)
{
    return rb->read_ptr == rb->write_ptr;
}


bool
ringbuf_full(ringbuf_t *rb)
{
    return (rb->read_ptr - rb->write_ptr) % rb->capacity == 1;
}


bool
ringbuf_push(ringbuf_t *rb, uint8_t octet)
{
    if (ringbuf_full(rb))
        return false;

    rb->data[rb->write_ptr] = octet;
    rb->write_ptr = (rb->write_ptr + 1) % rb->capacity;

    return true;
}


bool
ringbuf_pop(ringbuf_t *rb, uint8_t *octet)
{
    if (ringbuf_empty(rb))
        return false;

    *octet = rb->data[rb->read_ptr];
    rb->read_ptr = (rb->read_ptr + 1) % rb->capacity;

    return true;
}
