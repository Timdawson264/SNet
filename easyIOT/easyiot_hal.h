#pragma once
#include <stdint.h>

//Implement these functions to be part of the easyiot device network
//Device should set this value before including this header
#ifndef EASY_IOT_DIGITAL_IO_COUNT
    #define EASY_IOT_DIGITAL_IO_COUNT 0
#endif

typedef easiot_addr_t typeof()

extern void easyiot_set_digital_io( uint8_t id,  bool value );
extern bool easyiot_get_digital_io( uint8_t id );


//TODO: Design method for sending packets using the streaming nanopb method. Do the same for RX packets.


//extern void easyiot_send_pkt( uint16_t len, uint8_t* data );
