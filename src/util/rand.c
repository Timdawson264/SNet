#include "rand.h"

/* 
Adapted from https://burtleburtle.net/bob/rand/smallprng.html
*/

typedef struct rand_ctx { uint32_t a; uint32_t b; uint32_t c; uint32_t d; } rand_ctx;
static rand_ctx ctx;

void 
rand_init( uint32_t seed ) 
{
    ctx.a = 0xf1ea5eed;
    ctx.b = ctx.c = ctx.d = seed;
    
    uint8_t i;
    for (i=0; i<20; ++i) {
        (void)rand_val();
    }
}

#define rot(x,k) (((x)<<(k))|((x)>>(32-(k))))
uint32_t
rand_val() 
{
    uint32_t e = ctx.a - rot(ctx.b, 27);
    ctx.a = ctx.b ^ rot(ctx.c, 17);
    ctx.b = ctx.c + ctx.d;
    ctx.c = ctx.d + e;
    ctx.d = e + ctx.a;
    return ctx.d;
}



