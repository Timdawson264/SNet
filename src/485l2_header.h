#pragma once
#include <stdint.h>

typedef struct
{
    uint16_t dst_addr; //first so the rxing nodes can check fast
    uint16_t src_addr;
    uint8_t flags; //feature flats, ACK
    uint8_t port; //Also a type of data field, 0 reserved for control pkts
    uint16_t data_length;
    uint32_t data_crc; //this field is zeroed before calculating and checking.
    uint8_t data[];
}485l2_header;

