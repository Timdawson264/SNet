#ifndef SNET_INTERNAL_H__
#define SNET_INTERNAL_H__


#include "ringbuf.h"


#ifdef SNET_DEBUG
#define DEBUG(...)                                      \
    do {                                                \
        printf("%s:%d: ", __FILENAME__, __LINE__);      \
        printf(__VA_ARGS__);                            \
    } while (0)
#else
#define DEBUG(...)
#endif



typedef struct
{
	uint8_t preamble; // 0xAA
    uint16_t dst_addr; //first so the rxing nodes can check fast
    uint16_t src_addr;
    uint8_t flags; //feature flats, REQACK,ACK
    uint8_t port; //Also a type of data field, 0 reserved for control pkts
    uint16_t data_length;
    /* if data_length = 0 then below is not TXed */
    uint32_t data_crc; //this field is zeroed before calculating and checking.
    uint8_t data[]; //TODO: add c++ compiler exception to allow this naughty c code
}snet_pkt_header;




#endif
