.PHONY: clean flash all

CC=~/Downloads/sdcc-4.0.0/bin/sdcc
AR=~/Downloads/sdcc-4.0.0/bin/sdar

#../../src/snet.c
CFLAGS= -DSDCC -DSTM8S103 -mstm8 -I ./libstm8s/inc/ -I ../../src/ -I ../../src/util/ -L lib --std-sdcc99
LDFLAGS=-L ./lib/

libsnet_c := ../../src/snet.c ../../src/util/crc32.c ../../src/util/ringbuf.c  #../../src/util/printf.c 

libstm8_c := libstm8s/src/stm8s_clk.c libstm8s/src/stm8s_gpio.c libstm8s/src/stm8s_i2c.c libstm8s/src/stm8s_uart1.c libstm8s/src/stm8s_exti.c libstm8s/src/stm8s_flash.c libstm8s/src/stm8s_flash.c libstm8s/src/stm8s_tim1.c libstm8s/src/stm8s_tim2.c libstm8s/src/stm8s_tim4.c 
libstm8_o := $(libstm8_c:.c=.rel)

SRC_C := src/main.c src/snet_hal.c  $(libsnet_c)
SRC_O := $(SRC_C:.c=.rel)
#SRC_O := $(notdir $(SRC_C:.c=.rel))


LIBS := lib/libstm8s.a

all: lib/libstm8s.a bin/main.ihx

clean:
	-rm -f *.asm *.rel *.lst *.sym $(SRC_O) $(libstm8_o) $(LIBS) $(SRC_C:.c=.asm) $(SRC_C:.c=.lst) $(SRC_C:.c=.sym) $(SRC_C:.c=.rst) 
	-rm -rf bin lib

%.rel : %.c
	$(CC) -c $(CFLAGS) $< -o $@

lib/libstm8s.a : $(libstm8_o)
	mkdir -p lib
	$(AR) r $@ $^


bin/main.ihx : $(SRC_O)
	mkdir -p bin
	$(CC) $(CFLAGS) --out-fmt-ihx -o $@ $(LDFLAGS) -llibstm8s.a $^

flash: bin/main.ihx
	stm8flash -c stlinkv2 -w $< -p stm8s103f3
