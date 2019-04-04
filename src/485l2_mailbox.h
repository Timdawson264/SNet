#pragma once

<stdint.h>
"485l2_mailbox.h"

#define MAX_PKT_SIZE = 256;

typedef struct
{
    //flags - free,TXing,RXing.
    uint16_t cur_off; //current offset into data/header for tx/rx irq
    uint16_t max_off; //Max offset size - aka max header+pkt len
    //pkt + data
    485l2_pkt_header pkt;
    uint8_t data[MAX_PKT_SIZE];
} 485l2_mailbox;



