
#include <stdint.h>
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

uint16_t
ringbuf_size( ringbuf_t *rb )
{
	uint16_t read_ptr = rb->read_ptr;
	uint16_t write_ptr = rb->write_ptr;
	
	if( write_ptr >= read_ptr )
	{
		return ( write_ptr - read_ptr );
	}
	else
	{
		return ( rb->capacity - read_ptr ) + write_ptr;
	}
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

bool
ringbuf_peek(ringbuf_t *rb, uint16_t offset, uint8_t *octet)
{
	if ( offset > ringbuf_size(rb) )
		return false;
		
	uint16_t roffset = ( rb->read_ptr + offset ) % rb->capacity;
	*octet = rb->data[roffset];
		
	return true;
}

bool
ringbuf_seek( ringbuf_t *rb, uint16_t length ) 
{
	if( length > ringbuf_size(rb) )
		return false;
		
	rb->read_ptr = ( rb->read_ptr + length ) % rb->capacity;
	
	return true;
}
