#ifndef SNET_INTERNAL_H__
#define SNET_INTERNAL_H__

#include "lwrb/lwrb/src/include/lwrb/lwrb.h"
#include "util/crc32.h"

#ifdef SNET_DEBUG
#define DEBUG(...)                                      \
    do {                                                \
        printf("%s:%d: ", __FILENAME__, __LINE__);      \
        printf(__VA_ARGS__);                            \
    } while (0)
#else
#define DEBUG(...)
#endif

typedef enum
{
	SNET_PKT_FLAG_REQACK = (1<<0), /* Please Send an Ack packet back. */
	SNET_PKT_FLAG_ACK = (1<<1), /* This Packet Acks the just recived packet. */
	SNET_PKT_FLAG_CRC = (1<<2) /* There is a CRC at the end of this packet. */

} SNET_PKT_FLAG;

//Pack struct for with GCC
#ifdef __GNUC__ 
	#define PKATTR __attribute__((packed)) 
#else
	#define PKATTR
#endif

typedef struct
{
	uint8_t preamble; /* 0xAA */
    uint16_t dst_addr; 
    uint16_t src_addr;
    uint8_t flags; /* feature flats, REQACK,ACK,Jumbo Frame,CRC  */
    uint8_t data_length;
    uint8_t header_check; /* sum of header bytes MOD 255 of all previouse fields */    
} PKATTR snet_pkt_header;

typedef struct 
{
	snet_pkt_header header;
	/* if header.data_length = 0 then below is not TXed */
	uint8_t* data; /* header.data_length octets */
	uint32_t crc; /* Send if SNET_PKT_FLAG_CRC is set. */
	uint8_t priority; /* 0 - 7, default is 4, ACK is 0. TX Collision avoid multiplier. */ 
} snet_pkt;

#define SNET_PKT_HEADER_LEN sizeof( snet_pkt_header )

typedef enum
{
	SNET_TX_IDLE, /* TX Not Needed */
	SNET_TX_PREP, /* Prep to send Packet. */
	SNET_TX_BUS_WAIT, /* Doing collision avoidance waiting to start sending data */
	SNET_TX_TRANSMIT_START, /* Start Async or Sync TX */
	SNET_TX_TRANSMITTING, /* Bus is in TX and bytes are flowing, holding state. */
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
	/* Address of this node */
	const uint16_t ADDR;

    RX_STATE rx_state;    
    snet_pkt rx_pkt;
    lwrb_t rx_rb; /* Async RX */
	/* This tracks the last time bytes were recived on the bus */	
	volatile uint32_t last_rx_tick;

    TX_STATE tx_state;
    snet_pkt tx_pkt;
	/* This tracks the last TX frame sent, used for retransmit when REQACK set. */
	/* This is also used for random waiting on TX wait state */
	uint32_t tx_tick;

	/* Used for collition avoidance */
	uint8_t random;
} snet_stack_ctx;


#endif
