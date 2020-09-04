.PHONY: clean flash all

CC=~/Downloads/sdcc-4.0.0/bin/sdcc
AR=~/Downloads/sdcc-4.0.0/bin/sdar

#../../src/snet.c
CFLAGS= -DSTM8S103 -mstm8 -I ./libstm8s/inc/ -I ../../src/ -I ../../src/util/ --std-sdcc99
LDFLAGS=-L ./lib/ -llibsnet.a -llibstm8s.a

libsnet_c := ../../src/snet.c ../../src/util/crc32.c ../../src/util/ringbuf.c  #../../src/util/printf.c 
libstm8_c := libstm8s/src/stm8s_clk.c libstm8s/src/stm8s_gpio.c libstm8s/src/stm8s_i2c.c libstm8s/src/stm8s_uart1.c libstm8s/src/stm8s_exti.c libstm8s/src/stm8s_flash.c libstm8s/src/stm8s_flash.c libstm8s/src/stm8s_tim1.c libstm8s/src/stm8s_tim2.c libstm8s/src/stm8s_tim4.c 

libstm8_o := $(libstm8_c:.c=.rel)
libsnet_o := $(libsnet_c:.c=.rel)

SRC_C := src/main.c src/snet_hal.c
SRC_O := $(SRC_C:.c=.rel)

ALL_d := $(SRC_C:.c=.d) $(libsnet_c:.c=.d) $(libstm8_c:.c=.d)

LIBS := lib/libstm8s.a lib/libsnet.a
all: lib/libstm8s.a bin/main.ihx

clean:
	-rm -f $(LIBS) $(SRC_O) $(libstm8_o) $(libsnet_o) $(ALL_d) $(ALL_d:.d=.sym) $(ALL_d:.d=.asm) $(ALL_d:.d=.lst) $(ALL_d:.d=.rst)
	-rm -rf bin lib

-include $(ALL_d)
%.rel : %.c
	$(CC) -MMD -c $(CFLAGS) $< -o $@

lib/libstm8s.a : $(libstm8_o)
	mkdir -p lib
	$(AR) r $@ $^

lib/libsnet.a : $(libsnet_o)
	mkdir -p lib
	$(AR) r $@ $^

bin/main.ihx : $(SRC_O) | lib/libsnet.a lib/libstm8s.a
	mkdir -p bin
	$(CC) $(CFLAGS) --out-fmt-ihx -o $@ $(LDFLAGS) $^

flash: bin/main.ihx
	stm8flash -c stlinkv2 -w $< -p stm8s103f3
