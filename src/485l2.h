#pragma once


typedef struct
{
    //Bus timming info
    //Last idle time - last time idle cb was called
    //*current time // pointer to current time
    //State machine state
    //RX mailbox - mailbox incoming packets are written to
        
    //mailbox*[] - array of mailboxes* we pass packets to when they are for this node 
} 485l2_stack_ctx;

/**** IRQ safe functions *****/
//L1 - > L2 Call back functions
//func RX irq - get next byte
//func TX irq - send next byte
//func IDLE irq - update state machine

/**** called from main cpu context ****/
//poll_stack - this function does the state machine and all the heavy lifting (call whenever cpu wakes up for irq)
//send_pkt_blocking(src_mailbox*) - sends a packet, will block waiting for bus.

///sends a packet, returns and will call the callback when done
//when done_cb is null, then the mailbox can be polled to check if the packet has been sent
//send_pkt_nblocking(src_mailbox*, done_cb) - 

//register_mailbox(mailbox*) - add a user l3 mailbox to the stack

