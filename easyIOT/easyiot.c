

#include "easyiot.h"
#include "easyiot_hal.h"
#include "easyiot.pb.h"


//Use the nanopb library iostreams to incramentaly send packets.
//On Snet header match option should be there to call a nanopb decode callback. we can directly exec the io set/get. using decode cb.

// SNET_Rx -> easyiot_pkt_rx_cb -> nanopb_io_decode -> exec set/get
// nanopb encode -> snet_tx send with data cb.


//TODO: Implement PUB/SUB behaviour. with addr lists for PUB. say 16*snet_addr_t
