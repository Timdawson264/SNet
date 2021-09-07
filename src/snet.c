
#include "snet.h"
#include "util/rand.h"
#include "util/endian.h"

//#define SNET_DEBUG
#include "snet_internal.h"

#ifndef DEVICE_ADDR
	#define DEVICE_ADDR 0x0508
#endif
	

static uint8_t rx_buf[SNET_PKT_HEADER_LEN*2]; //should be atleast SNET_PKT_HEADER_LEN size
static snet_stack_ctx stack_ctx = {
	.ADDR = DEVICE_ADDR,
	.tx_tick = 0,
	.last_rx_tick = 0,
	.rx_state = SNET_RX_PREAMBLE,
	.tx_state = SNET_TX_IDLE,
};

/* BUS Timmings */
//#define SNET_BUS_BYTE_TIME  ( 1000000ul / ( (uint32_t) SNET_HAL_BAUDRATE / 8ul ) )

//MAX packet time is 255 + SNET_PKT_HEADER_LEN 
/* Time in uS for a packet to TX */
//#define SNET_PKT_HEADER_TIME ((uint32_t) ( SNET_PKT_HEADER_LEN  * SNET_BUS_BYTE_TIME ) )

//Time before we resend after waiting for an ACK 
//#define SNET_ACK_TIMEOUT ((uint32_t) SNET_PKT_HEADER_TIME * 2 )
#define SNET_ACK_TIMEOUT (10)
//Time to wait after bus idle before packet send.
#define SNET_PKT_CA_TIME(N) ( SNET_ACK_TIMEOUT * ( 1 + (N) ) )

//Timeout between preamble and rest of header
#define SNET_RX_TIMEOUT (100)

//https://en.wikipedia.org/wiki/Carrier-sense_multiple_access
//Below TX state machine implements Non-persistent type

#if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__

void
snet_pkt_hdr_endian_swap( snet_pkt_header *pkt_header )
{
	pkt_header->dst_addr = __bswap16( pkt_header->dst_addr ); 
    pkt_header->src_addr = __bswap16( pkt_header->src_addr );
}

#else

#define snet_pkt_hdr_endian_swap( P ) (void) P

#endif



void
snet_init(void)
{
    DEBUG("init\n PKT_HDR_LEN: %u\n\n", SNET_PKT_HEADER_LEN);

	//TODO: Compile time assert
	//assert( sizeof( rx_buf ) > SNET_HEADER_LEN );
	lwrb_init( &stack_ctx.rx_rb, rx_buf, sizeof(rx_buf) );

	/* Using the ADDR as the Rand seed should help stop collisions */
	rand_init( (uint32_t)stack_ctx.ADDR );

    snet_hal_init();
	snet_hal_set_direction(SNET_HAL_DIR_RX);
}

void
snet_update(void)
{	
	switch( (stack_ctx.tx_state) )
	{
		/* Do nothing we have no TX work todo */
		/*
		case SNET_TX_IDLE: 
		{	
			break;
		}
		*/
		/* Check if Bus is IDLE, if not we must wait a random delay */
		case SNET_TX_PREP:
		{
			DEBUG("STATE: TX_PREP\n");

			/* Even if the Systick rolls over, the difference is unsigned
			   so will return true and progress.
			   TODO: replace this random backoff send with a probabilistic one.
			*/
			uint16_t idle_time = SNET_PKT_CA_TIME( stack_ctx.tx_pkt.priority & 0x0F );
			uint16_t time_since_bytes = snet_hal_get_ticks() - stack_ctx.last_rx_tick;
			if( time_since_bytes >= idle_time )
			{
				// Bus idle TX now.
				stack_ctx.tx_state = SNET_TX_TRANSMIT_START;
			}
			else
			{
				//Bus not Idle Wait Random Time
				//Select A random time now. so we can poll wait in next state.
				//random wait ~0-16ms
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
			DEBUG("STATE: TX_BUS_WAIT\n");
			//DO collision avoidance random wait here, polled...
			uint16_t wait_time = stack_ctx.random;
			/* This is the Time since we last tried to TX but found a busy bus */
			uint16_t time_since_prep = snet_hal_get_ticks() - stack_ctx.tx_tick;
			
			if( time_since_prep >= wait_time )
			{
				//Random stand down done, try again.
				stack_ctx.tx_state = SNET_TX_PREP;
			}
			break;
		}
		case SNET_TX_TRANSMIT_START:
		{
			DEBUG("STATE: TX_TRANSMIT_START\n");
			snet_hal_set_direction( SNET_HAL_DIR_TX );

			//TODO: Switch to iovec and async
			snet_pkt_hdr_endian_swap( &stack_ctx.tx_pkt.header );
			snet_hal_transmit( (uint8_t*)&stack_ctx.tx_pkt.header, SNET_PKT_HEADER_LEN );
			snet_pkt_hdr_endian_swap( &stack_ctx.tx_pkt.header );
			
			snet_hal_transmit( stack_ctx.tx_pkt.data, stack_ctx.tx_pkt.header.data_length );

			//TODO: Suppport iostreams - to allow low memory messages.
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
			DEBUG("STATE: TX_TRANSMITTING\n");
			
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
			DEBUG("STATE: TX_ACK_WAIT\n");
			uint32_t time_since_tx = snet_hal_get_ticks() - stack_ctx.tx_tick;
			if( (time_since_tx > SNET_ACK_TIMEOUT) )
			{
				stack_ctx.tx_state = SNET_TX_PREP; //resend
			}
			break;
		}
	}


	switch( stack_ctx.rx_state )
	{
		// case SNET_RX_IDLE:
		// {
		// 	break;
		// }
		case SNET_RX_PREAMBLE:
		{
			DEBUG("STATE: SNET_RX_PREAMBLE\n");

#ifdef SNET_DEBUG
			size_t rx_len = lwrb_get_full(&stack_ctx.rx_rb);
			if (rx_len>0)
			{
				DEBUG("RECV: %i Bytes\n", rx_len);
			}
#endif

			//while we are in this state and there is bytes to check.
			while( (stack_ctx.rx_state == SNET_RX_PREAMBLE) && ( lwrb_get_full( &stack_ctx.rx_rb ) > 0 ) )
			{  
				//look for 0xAA start of header.
				//if not 0xAA consume.
				uint8_t* buf_ptr = lwrb_get_linear_block_read_address( &stack_ctx.rx_rb );
				size_t buf_len = lwrb_get_linear_block_read_length( &stack_ctx.rx_rb );
				size_t skip_len = 0;

				for (size_t i = 0; i < buf_len; i++)
				{
					if (buf_ptr[i] == 0xAA)
					{
						//start checking for real header now
						stack_ctx.rx_state = SNET_RX_HEADER;
						break;
					}
					skip_len++; //skip all non preamble bytes
				}
				DEBUG("SKIP\n");
				lwrb_skip(&stack_ctx.rx_rb, skip_len);
			}

			break;
		}
		case SNET_RX_HEADER:
		{
			DEBUG("STATE: SNET_RX_HEADER\n");
			//see if we have a full header worth of data.
			if (lwrb_get_full(&stack_ctx.rx_rb) < SNET_PKT_HEADER_LEN)
			{
				//lets not wait forever - last_rx_tick set by snet stack in RX function.
				uint32_t timeout = snet_hal_get_ticks() - stack_ctx.last_rx_tick;
				if ( timeout > SNET_RX_TIMEOUT )
				{
					stack_ctx.rx_state = SNET_RX_PREAMBLE;
				}
				break;
			}

			lwrb_read(&stack_ctx.rx_rb, (void *)&stack_ctx.rx_pkt.header, SNET_PKT_HEADER_LEN);
			uint8_t check = snet_calc_header_checksum( &stack_ctx.rx_pkt.header );
			snet_pkt_hdr_endian_swap( &stack_ctx.rx_pkt.header ); //byte ordering is not important, header checksum is commutative

			snet_pkt_header *hdr = &stack_ctx.rx_pkt.header;
			DEBUG("HDR:\n DST %u\n SRC: %u\n LEN: %u\n CHK: %u\n\n", hdr->dst_addr, hdr->src_addr, hdr->data_length, hdr->header_check);

			if(  check != stack_ctx.rx_pkt.header.header_check )
			{
				//No good try again.
				DEBUG("BAD HEADER CHECK: %u\n", check );
				stack_ctx.rx_state = SNET_RX_PREAMBLE;
				break;
			}
			else
			{
				//IF - ADDR = us or Braodcast and if MTU > MAX_MTU. 
				//ELSE - 

				//now get the data.
				DEBUG("GOOD HEADER CHECK\n");
				stack_ctx.data_length_remaining = stack_ctx.rx_pkt.header.data_length;
				stack_ctx.rx_state = SNET_RX_DATA;
			}
		}
		case SNET_RX_DATA:
		{
			if( stack_ctx.data_length_remaining > 0 )
			{
				DEBUG("STATE: SNET_RX_DATA - DATA\n");
				//rx the data portion of the packet + maybe a crc
				//
				size_t buf_s = lwrb_get_full(&stack_ctx.rx_rb);
				size_t recv_len = MIN(buf_s, stack_ctx.data_length_remaining);

				if( recv_len )
				{
					//Calc buffer offset.
					size_t offset = stack_ctx.rx_pkt.header.data_length - stack_ctx.data_length_remaining;
					lwrb_read(&stack_ctx.rx_rb, &stack_ctx.rx_pkt.data[offset], recv_len);
					//TODO Also partial CRC could be done here. - if we need to
					stack_ctx.data_length_remaining -= recv_len;
				}
			}
			else
			{
				/* Now we need to check if we need to find the CRC */
				if( stack_ctx.rx_pkt.header.flags & SNET_PKT_FLAG_CRC )
				{
					if( lwrb_get_full(&stack_ctx.rx_rb) < 4 )
					{
						break; //crc not in ringbuf.
					}
					else
					{
						//read in CRC
						lwrb_read(&stack_ctx.rx_rb, &stack_ctx.rx_pkt.crc, sizeof(stack_ctx.rx_pkt.crc) );
						//TODO: Check the CRC is correct.
						//If they match, we can continue.

						stack_ctx.rx_state = SNET_RX_FINAL;
					}
				}
				else
				{
					stack_ctx.rx_state = SNET_RX_FINAL;
				}
			}
			break;
		}
		case SNET_RX_SKIP_DATA:
		{
			if( stack_ctx.data_length_remaining > 0 )
			{
				size_t buf_s = lwrb_get_full(&stack_ctx.rx_rb); //Data in Buf
				size_t len = MIN(buf_s, stack_ctx.data_length_remaining); //ammount to skip
				lwrb_skip( &stack_ctx.rx_rb, len );
				stack_ctx.data_length_remaining -= len;
			}
			else
			{
				stack_ctx.rx_state = SNET_RX_PREAMBLE; //NEXT PACKET.
			}
			break;
		}
		case SNET_RX_FINAL:
		{

			stack_ctx.rx_state = SNET_RX_PREAMBLE;
			DEBUG("STATE: SNET_RX_FINAL\n");
			//Check optional CRC if its there.
			//handoff packet.

			//SEND The ACK. - dont need to check the bus as we still have authority. straight after the RX Finished.
			if( stack_ctx.rx_pkt.header.flags & SNET_PKT_FLAG_REQACK )
			{
				//SEND ACK.
				stack_ctx.rx_ack_hdr.preamble = 0xAA;
				stack_ctx.rx_ack_hdr.flags = SNET_PKT_FLAG_ACK;
				stack_ctx.rx_ack_hdr.dst_addr = stack_ctx.rx_pkt.header.src_addr;
				stack_ctx.rx_ack_hdr.src_addr = stack_ctx.ADDR;
				stack_ctx.rx_ack_hdr.data_length = 0;
				stack_ctx.rx_ack_hdr.header_check = snet_calc_header_checksum( &stack_ctx.rx_ack_hdr );
				snet_pkt_hdr_endian_swap( &stack_ctx.rx_ack_hdr ); //CPU -> NETWORK.

				snet_hal_set_direction( SNET_HAL_DIR_TX );
				snet_hal_transmit( (uint8_t*) &stack_ctx.rx_ack_hdr, SNET_PKT_HEADER_LEN );

			}

			break;
		}
	}

    /* Process any received data. */
    //~ while (ringbuf_pop(&stack_ctx.rx_rb, &ch))
    //~ {
        //~ DEBUG("%02x\n", ch);
    //~ }
}

uint8_t 
snet_calc_header_checksum( snet_pkt_header *pkt_header )
{
	uint8_t old_chk = pkt_header->header_check;
	pkt_header->header_check = 0;

	uint8_t *header = (uint8_t *)pkt_header;
	uint8_t sum = 0;
	for( size_t i=0; i<SNET_PKT_HEADER_LEN; i++)
	{
		sum += header[i];
	}

	pkt_header->header_check = old_chk;
	return sum;
}

bool
snet_send( uint8_t* data, uint16_t length, snet_addr_t dst_addr, bool req_ack, bool crc, uint8_t priority )
{
	if( stack_ctx.tx_state != SNET_TX_IDLE )
			return false;
			
	stack_ctx.tx_pkt.priority = priority;

	//this kinda sucks... need to use a nice serialization library.

	//Reset header
	memset( (void*) &stack_ctx.tx_pkt.header, 0, SNET_PKT_HEADER_LEN );
	stack_ctx.tx_pkt.header.preamble = 0xAA;
	stack_ctx.tx_pkt.header.dst_addr = dst_addr;
	stack_ctx.tx_pkt.header.src_addr = stack_ctx.ADDR;
	stack_ctx.tx_pkt.header.data_length = length;
	memcpy(stack_ctx.tx_pkt.data, data, length);
	
	if( req_ack ) 
	{
		stack_ctx.tx_pkt.header.flags |= SNET_PKT_FLAG_REQACK;
	}

	if( crc )
	{
		stack_ctx.tx_pkt.header.flags |= SNET_PKT_FLAG_CRC;
		stack_ctx.tx_pkt.crc = snet_crc32_bitwise( data, length );
	}
	
	stack_ctx.tx_pkt.header.header_check = snet_calc_header_checksum( &stack_ctx.tx_pkt.header );

	//Start the TX chain of events
	stack_ctx.tx_state = SNET_TX_PREP;
	
	return true;
}


void
snet_hal_receive(uint8_t *data, uint16_t length)
{	
	stack_ctx.last_rx_tick = snet_hal_get_ticks();
	lwrb_write( &stack_ctx.rx_rb, data, length);
}

void
snet_hal_receive_byte(uint8_t data)
{
	snet_hal_receive( &data, 1 );
}