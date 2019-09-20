#pragma once

typedef enum
{
	IDLE,
	BUS_WAIT,
	TRANSMITTING,
	ACK_WAIT
} TX_STATE;

typedef enum
{
	IDLE,
	RECEIVING
} RX_STATE;

typedef struct
{
    //Bus timming info
    //Last idle time - last time idle cb was called
    //*current time // pointer to current time
    RX_STATE rx_state;    
    snet_pkt_header * rx_pkt;
    
    TX_STATE tx_state;
    //Time of PKT tx, for ACK timeout
    snet_pkt_header * tx_pkt;
    
} 485l2_stack_ctx;

/**** Functions implemented by the hardware spesific implementation *****/
//L2 - > L1 functions
//func - setup(void* settings) //Enables all the pins set up all the hardware - can pass datastructer of UART port etc.
//func - init_RX // i want to start RXing again - sets the RS485 transciver to RX mode.
//func - init_TX //I want to start a TX - sets the RS485 transciver to TX mode and sends the pkt.


/**** called from main cpu context ****/
///this function does the state machine and all the heavy lifting (call whenever cpu wakes up for irq)
// or can be polled at a high rate.
//poll_stack
//send_pkt_blocking(src_mailbox*) - sends a packet - (spins on poll_stack)
//recv_pkt_blocking(dst_mailbox*) - waits for a pkt and blocks (spins on poll_stack)

///sends a packet, returns and will call the callback when done
//when done_cb is null, then the mailbox can be polled to check if the packet has been sent
//send_pkt_nblocking(src_mailbox*, done_cb).

//register_mailbox(mailbox*) - add a user l3 mailbox to the stack

