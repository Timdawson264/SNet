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

/** Bus max packet size for this device */
#define SNET_HAL_MTU (64)
#define SNET_BROADCAST_ADDR (0xffff)

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

//BAD EVALS X and Y twice. done use funcs.
#define MIN(X,Y) ( (X) < (Y) ? (X) : (Y) )

typedef struct
{
    uint8_t preamble; /* 0xAA */
    snet_addr_t dst_addr; 
    snet_addr_t src_addr;
    uint8_t flags; /* feature flats, REQACK,ACK,Jumbo Frame,CRC  */
    uint8_t data_length;
    uint8_t header_check; /* sum of header bytes MOD 255 of all previouse fields */    
} PKATTR snet_pkt_header;

#define SNET_PKT_HEADER_LEN (sizeof( snet_pkt_header ))

typedef struct 
{
	snet_pkt_header header;
	
	/* if header.data_length = 0 then below is not TXed */
	uint8_t data[SNET_HAL_MTU]; /* header.data_length octets */
	uint32_t crc; /* Send if SNET_PKT_FLAG_CRC is set. */
	uint8_t priority; /* 0 - 7, default is 4, ACK is 0. TX Collision avoid multiplier. */ 
} snet_pkt;


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
	SNET_RX_PREAMBLE, /* RX 0xAA */
	SNET_RX_HEADER, /* Looking for a valid packet header */
	SNET_RX_DATA, /* Copying data bytes and calculating CRC */
	SNET_RX_SKIP_DATA, /* Same as above but dont keep anything */ 
	SNET_RX_FINAL /* Header and Data Assembled, Just need to call CBs etc. */
} RX_STATE;

typedef struct
{
	/* Address of this node */
	const snet_addr_t ADDR;

    RX_STATE rx_state;
    snet_pkt rx_pkt;
	snet_pkt_header rx_ack_hdr;
    lwrb_t rx_rb; /* Async RX ringbuffer irq -> update loop */
	/*data left to recv */
	uint8_t data_length_remaining;

	/* This tracks the last time bytes were recived on the bus */	
	volatile uint32_t last_rx_tick;

    TX_STATE tx_state;
    snet_pkt tx_pkt;
	/* This tracks the last TX frame sent, used for retransmit when REQACK set. */
	/* This is also used for random waiting on TX wait state */
	uint32_t tx_tick;
	/* Number of TX attempts left with no ACK/Corrupt responses */
	uint8_t tx_retries_remaining;

	/* Used for tx collition avoidance */
	uint8_t random;
} snet_stack_ctx;

uint8_t
snet_calc_header_checksum(snet_pkt_header *pkt_header);

#endif
