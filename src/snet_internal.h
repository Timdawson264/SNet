#ifndef SNET_INTERNAL_H__
#define SNET_INTERNAL_H__


#include "ringbuf.h"
#include "crc32.h"

#ifdef SNET_DEBUG
#define DEBUG(...)                                      \
    do {                                                \
        printf("%s:%d: ", __FILENAME__, __LINE__);      \
        printf(__VA_ARGS__);                            \
    } while (0)
#else
#define DEBUG(...)
#endif

#define SNET_PKT_FLAG_REQACK (1<<0)
#define SNET_PKT_FLAG_ACK (1<<1)

typedef struct
{
	uint8_t preamble; /* 0xAA */
    uint16_t dst_addr; 
    uint16_t src_addr;
    uint8_t flags; /* feature flats, REQACK,ACK */
    uint16_t data_length;
    uint8_t header_check; /* sum of header bytes MOD 255 of all previouse fields */    
    /* uint32_t data_crc; CRC follows data */
}snet_pkt_header;

typedef struct 
{
	snet_pkt_header header;
	/* if header.data_length = 0 then below is not TXed */
	uint8_t* data; /* header.data_length octets */
	uint32_t crc;
	uint8_t priority; /* 0 - 7, default is 7, ACK is 0 */ 
} snet_pkt;

#define SNET_PKT_HEADER_LEN sizeof( snet_pkt_header )

typedef enum
{
	SNET_TX_IDLE, /* TX Not Needed */
	SNET_TX_PREPED, /* TX is setup */
	SNET_TX_BUS_WAIT, /* Doing collision avoidance */
	SNET_TX_TRANSMITTING, /*Bus is in TX and bytes are flowing */
	SNET_TX_ACK_WAIT      /* we set ACKREQ and are waiting for a response */
} TX_STATE;

typedef enum
{
	SNET_RX_IDLE,  /* RX is Disabled */
	SNET_RX_HEADER, /* Looking for a valid packet header */
	SNET_RX_DATA, /* Copying databytes and calculating CRC */
	SNET_RX_FINAL /* Header and Data Assembled, Just need to call CBs etc. */
} RX_STATE;

typedef struct
{
	uint16_t ADDR;
    //Bus timming info
    //Last idle time - last time idle cb was called
    //*current time // pointer to current time
    RX_STATE rx_state;    
    snet_pkt rx_pkt;
    ringbuf_t rx_rb; //Async RX
        
    TX_STATE tx_state;
    //Time of PKT tx, for ACK timeout
    snet_pkt tx_pkt;
} snet_stack_ctx;

#endif
