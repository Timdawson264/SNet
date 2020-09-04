#include "snet.h"

//#define SNET_DEBUG
#include "snet_internal.h"


//TODO: Async TX
//TODO: Irq RX
static uint8_t rx_buf[64];
static snet_stack_ctx stack_ctx;

void
snet_init(void)
{
    DEBUG("init\n");

	//TODO: Compile time assert
	//assert( sizeof( rx_buf ) > SNET_HEADER_LEN );
    ringbuf_init(&stack_ctx.rx_rb, rx_buf, sizeof(rx_buf));

    snet_hal_init();
    snet_hal_set_direction(SNET_HAL_DIR_RX);
    stack_ctx.ADDR = 1;
}

void
snet_update(void)
{
	
	switch( stack_ctx.tx_state )
	{
		case SNET_TX_IDLE: 
		{
			break;
		}
		case SNET_TX_BUS_WAIT:
		{
			//DO collision avoidance here
			//if last seen time < avoid time. break

			//else set bus to TX and send.
			snet_hal_set_direction( SNET_HAL_DIR_TX );
			//TODO: Switch to iovec and async
			snet_hal_transmit( (uint8_t*)&stack_ctx.tx_pkt.header, SNET_PKT_HEADER_LEN );
			snet_hal_transmit( stack_ctx.tx_pkt.data, stack_ctx.tx_pkt.header.data_length );
			snet_hal_transmit( (uint8_t*)&stack_ctx.tx_pkt.crc, sizeof(stack_ctx.tx_pkt.crc) );
			break;
		}
		case SNET_TX_TRANSMITTING:
		{
			if( snet_hal_is_transmitting() )
				break;
				
			snet_hal_set_direction( SNET_HAL_DIR_RX );

			//Decide next state based on REQACK flag
			if( stack_ctx.tx_pkt.header.flags & SNET_PKT_FLAG_REQACK != 0 )
			{
				//We need to now wait for the ack
				stack_ctx.tx_state = SNET_TX_ACK_WAIT;
				//TODO: record systick time for retry timing
			}
			else
			{
				//We Done
				stack_ctx.tx_state = SNET_TX_IDLE;	
			}
			break;
		}
		case SNET_TX_ACK_WAIT:
		{
			//if( cur_time - TX_TIME > retry_timeout )
			//	stack_ctx.tx_state = SNET_TX_BUS_WAIT; //resend
			break;
		}
	}


	switch( stack_ctx.rx_state )
	{
		case SNET_RX_IDLE:
		{
			break;
		}
		case SNET_RX_HEADER:
		{
			break;
		}
		case SNET_RX_DATA:
		{
			break;
		}
		case SNET_RX_FINAL:
		{
			break;
		}
	}

    /* Process any received data. */
    //~ while (ringbuf_pop(&stack_ctx.rx_rb, &ch))
    //~ {
        //~ DEBUG("%02x\n", ch);
    //~ }
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

bool
snet_send( uint8_t* data, uint16_t length, uint16_t dst_addr, bool req_ack )
{
	if( stack_ctx.tx_state != SNET_TX_IDLE )
			return false;
			
	stack_ctx.tx_pkt.priority = 7;
	memset( (void*) &stack_ctx.tx_pkt.header, 0, SNET_PKT_HEADER_LEN );
	stack_ctx.tx_pkt.header.preamble = 0xAA;
	stack_ctx.tx_pkt.header.dst_addr = dst_addr;
	stack_ctx.tx_pkt.header.src_addr = stack_ctx.ADDR;
	stack_ctx.tx_pkt.data = data;
	stack_ctx.tx_pkt.header.data_length = length;		
	if( req_ack )
		stack_ctx.tx_pkt.header.flags = SNET_PKT_FLAG_REQACK;
	
	snet_calc_header_checksum( &stack_ctx.tx_pkt.header );
	stack_ctx.tx_pkt.crc = snet_crc32_bitwise( data, length );
	
	//Start the TX chain of events
	stack_ctx.tx_state = SNET_TX_BUS_WAIT;
	
	return true;
}


void
snet_hal_receive(uint8_t *data, uint16_t length)
{
    int i;

    for (i = 0; i < length; i++)
    {
        ringbuf_push(&stack_ctx.rx_rb, data[i]);
    }
}

void
snet_hal_receive_byte(uint8_t data)
{
	ringbuf_push(&stack_ctx.rx_rb, data);   
}