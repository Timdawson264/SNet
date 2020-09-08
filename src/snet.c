#include "snet.h"
#include "rand.h"

//#define SNET_DEBUG
#include "snet_internal.h"

#ifndef DEVICE_ADDR
	#define DEVICE_ADDR 0x0001
#endif
	

static uint8_t rx_buf[64];
static snet_stack_ctx stack_ctx = {
	.ADDR = DEVICE_ADDR,
	.tx_tick = 0,
	.last_rx_tick = 0
};

/* BUS Timmings */
//#define SNET_BUS_BYTE_TIME  ( 1000000ul / ( (uint32_t) SNET_HAL_BAUDRATE / 8ul ) )

//MAX packet time is 255 + SNET_PKT_HEADER_LEN 
/* Time in uS for a packet to TX */
//#define SNET_PKT_HEADER_TIME ((uint32_t) ( SNET_PKT_HEADER_LEN  * SNET_BUS_BYTE_TIME ) )

//Time before we resend after waiting for an ACK 
//#define SNET_ACK_TIMEOUT ((uint32_t) SNET_PKT_HEADER_TIME * 2 )
#define SNET_ACK_TIMEOUT 1
//Time to wait after bus idle before packet send.
#define SNET_PKT_CA_TIME(N) ( SNET_ACK_TIMEOUT * ( 1 + (N) ) )

//https://en.wikipedia.org/wiki/Carrier-sense_multiple_access
//Below TX state machine implements Non-persistent type

void
snet_init(void)
{
    DEBUG("init\n");

	//TODO: Compile time assert
	//assert( sizeof( rx_buf ) > SNET_HEADER_LEN );
    ringbuf_init(&stack_ctx.rx_rb, rx_buf, sizeof(rx_buf));

	/* Using the ADDR as the Rand seed should help stop collisions */
	rand_init( (uint32_t)stack_ctx.ADDR );

    snet_hal_init();
	snet_hal_set_direction(SNET_HAL_DIR_RX);
}

bool
_snet_update(void)
{	
	switch( stack_ctx.tx_state )
	{
		// case SNET_TX_IDLE: 
		// {
		// 	(void) stack_ctx;	
		// 	break;
		// }
		
		/* Check if Bus is IDLE, if not we must wait a random delay */
		case SNET_TX_PREP:
		{
			/* Even if the Systick rolls over, the difference is unsigned
			   so will return true and progress.
			*/
			uint16_t idle_time = SNET_PKT_CA_TIME( stack_ctx.tx_pkt.priority & 0x0F );
			uint32_t time_since_bytes = snet_hal_get_ticks() - stack_ctx.last_rx_tick;
			if( time_since_bytes >= idle_time )
			{
				// Bus idle TX now.
				stack_ctx.tx_state = SNET_TX_TRANSMIT_START;
			}
			else
			{
			// 	//Bus not Idle Wait Random Time
			// 	//Select A random time now. so we can poll wait in next state.
			// 	//0-128 bytes random wait ~0-16ms
				stack_ctx.random = (uint8_t) rand_val() & 0x0F;
				//Record the time now. so we can calculate when random wait is over.
				stack_ctx.tx_tick = snet_hal_get_ticks();
				stack_ctx.tx_state = SNET_TX_BUS_WAIT;
			}
			/* Intentional fall through */
			break;
		}
		/* Waiting for random time before attempting to TX */
		case SNET_TX_BUS_WAIT:
		{
			//DO collision avoidance random wait here, polled...
			uint32_t wait_time = stack_ctx.random;
			/* This is the Time since we last tried to TX but found a busy bus */
			uint32_t time_since_prep = snet_hal_get_ticks() - stack_ctx.tx_tick;
			
			if( time_since_prep >= wait_time )
			{
				//Random stand down done, try again.
				stack_ctx.tx_state = SNET_TX_PREP;
			}
			break;
		}
		case SNET_TX_TRANSMIT_START:
		{
			snet_hal_set_direction( SNET_HAL_DIR_TX );
			//TODO: Switch to iovec and async
			snet_hal_transmit( (uint8_t*)&stack_ctx.tx_pkt.header, SNET_PKT_HEADER_LEN );
			snet_hal_transmit( stack_ctx.tx_pkt.data, stack_ctx.tx_pkt.header.data_length );
			if( stack_ctx.tx_pkt.header.flags & SNET_PKT_FLAG_CRC )
			{
				snet_hal_transmit( (uint8_t*)&stack_ctx.tx_pkt.crc, sizeof(stack_ctx.tx_pkt.crc) );
			}

			//TX Queued
			stack_ctx.tx_state = SNET_TX_TRANSMITTING;
			/* Intentional fall through */
		}
		case SNET_TX_TRANSMITTING:
		{
			//Micro is still sending data
			if( snet_hal_is_transmitting() ) break;

			//TX is finished, we can switch back to Listening.
			snet_hal_set_direction( SNET_HAL_DIR_RX );
			//Record time TX finished, so we can judge when to retransmit.
			//Also count as RX so we dont DOS the bus (for random waits).
			stack_ctx.last_rx_tick = stack_ctx.tx_tick = snet_hal_get_ticks();
			//Decide next state based on REQACK flag
			if( stack_ctx.tx_pkt.header.flags & SNET_PKT_FLAG_REQACK )
			{
				//We need to now wait for the ack
				stack_ctx.tx_state = SNET_TX_ACK_WAIT;
			}
			else
			{
				//We are done
				stack_ctx.tx_state = SNET_TX_IDLE;	
			}
			break;
		}
		case SNET_TX_ACK_WAIT:
		{	
			uint32_t time_since_tx = snet_hal_get_ticks() - stack_ctx.tx_tick;
			if( time_since_tx > SNET_ACK_TIMEOUT )
			{
				stack_ctx.tx_state = SNET_TX_PREP; //resend
			}
			break;
		}
	}


	// switch( stack_ctx.rx_state )
	// {
	// 	case SNET_RX_IDLE:
	// 	{
	// 		break;
	// 	}
	// 	case SNET_RX_HEADER:
	// 	{
	// 		break;
	// 	}
	// 	case SNET_RX_DATA:
	// 	{
	// 		break;
	// 	}
	// 	case SNET_RX_FINAL:
	// 	{
	// 		break;
	// 	}
	// }

    /* Process any received data. */
    //~ while (ringbuf_pop(&stack_ctx.rx_rb, &ch))
    //~ {
        //~ DEBUG("%02x\n", ch);
    //~ }

	return false;
}

void 
snet_calc_header_checksum( snet_pkt_header *pkt_header )
{
	pkt_header->header_check = 0;	
	uint8_t * header = (uint8_t*)pkt_header;

	uint8_t result = 0;
	for( size_t i=0; i<SNET_PKT_HEADER_LEN; i++)
	{
		result = ( result + header[i] ) & 0xff ;
	}

	pkt_header->header_check = result;
}

void
snet_update(void)
{
	//uint8_t i;
	//for( i=0; i < 4 && _snet_update() ; i++ );

	_snet_update();
}


bool
snet_send( uint8_t* data, uint16_t length, uint16_t dst_addr, bool req_ack, bool crc, uint8_t priority )
{
	if( stack_ctx.tx_state != SNET_TX_IDLE )
			return false;
			
	stack_ctx.tx_pkt.priority = priority;
	//Reset header
	memset( (void*) &stack_ctx.tx_pkt.header, 0, SNET_PKT_HEADER_LEN );
	stack_ctx.tx_pkt.header.preamble = 0xAA;
	stack_ctx.tx_pkt.header.dst_addr = dst_addr;
	stack_ctx.tx_pkt.header.src_addr = stack_ctx.ADDR;
	stack_ctx.tx_pkt.data = data;
	stack_ctx.tx_pkt.header.data_length = length;		

	if( req_ack ) 
	{
		stack_ctx.tx_pkt.header.flags |= SNET_PKT_FLAG_REQACK;
	}

	if( crc )
	{
		stack_ctx.tx_pkt.header.flags |= SNET_PKT_FLAG_CRC;
		stack_ctx.tx_pkt.crc = snet_crc32_bitwise( data, length );
	}
	
	snet_calc_header_checksum( &stack_ctx.tx_pkt.header );

	//Start the TX chain of events
	stack_ctx.tx_state = SNET_TX_PREP;
	
	return true;
}


void
snet_hal_receive(uint8_t *data, uint16_t length)
{
	(void) data;
	(void) length;
    //int i;
	
	stack_ctx.last_rx_tick = snet_hal_get_ticks();

    // for (i = 0; i < length; i++)
    // {
    //     ringbuf_push(&stack_ctx.rx_rb, data[i]);
    // }
}

void
snet_hal_receive_byte(uint8_t data)
{
	(void) data;
 	stack_ctx.last_rx_tick = snet_hal_get_ticks();
	//ringbuf_push(&stack_ctx.rx_rb, data);   
}