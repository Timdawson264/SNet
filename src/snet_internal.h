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
    uint16_t data_length;
    /* if data_length = 0 then below is not TXed */
    uint32_t data_crc; //this field is zeroed before calculating and checking.
    uint8_t data[]; //TODO: add c++ compiler exception to allow this naughty c code
}snet_pkt_header;


typedef enum
{
	SNET_TX_IDLE,
	SNET_TX_BUS_WAIT, /* Doing collision avoidance */
	SNET_TX_TRANSMITTING, /*Bus is in TX and bytes are flowing */
	SNET_TX_ACK_WAIT      /* we set ACKREQ and are waiting for a response */
} TX_STATE;

typedef enum
{
	SNET_RX_IDLE,
	SNET_RX_RECEIVING
} RX_STATE;

typedef struct
{
    //Bus timming info
    //Last idle time - last time idle cb was called
    //*current time // pointer to current time
    RX_STATE rx_state;    
    snet_pkt_header * rx_pkt;
    ringbuf_t rx_rb; //Async RX

    TX_STATE tx_state;
    //Time of PKT tx, for ACK timeout
    snet_pkt_header * tx_pkt;
    
} snet_stack_ctx;

#endif
