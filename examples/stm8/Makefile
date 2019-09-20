CC=sdcc
AR=sdar

CFLAGS=-DSDCC -DSTM8S103 --opt-code-size -mstm8 -I ./libstm8s/inc/ -L lib --std-sdcc99
LDFLAGS=-L ./lib/

libstm8_c := libstm8s/src/stm8s_clk.c libstm8s/src/stm8s_gpio.c libstm8s/src/stm8s_i2c.c libstm8s/src/stm8s_uart1.c libstm8s/src/stm8s_exti.c libstm8s/src/stm8s_flash.c libstm8s/src/stm8s_flash.c libstm8s/src/stm8s_tim1.c libstm8s/src/stm8s_tim2.c libstm8s/src/stm8s_tim4.c 
libstm8_o := $(libstm8_c:.c=.rel)

SRC_C := src/main.c
LIBS := lib/libstm8s.a

all: bin/main.ihx

clean:
	-rm -f *.asm *.rel *.lst *.sym
	-rm -f libstm8s/src/*.asm libstm8s/src/*.rel libstm8s/src/*.lst libstm8s/src/*.sym
	-rm -rf bin lib

%.rel : %.c
	$(CC) -c $(CFLAGS) $< -o $@

lib/libstm8s.a : $(libstm8_o)
	mkdir lib
	$(AR) r $@ $^


bin/main.ihx : $(SRC_C) $(LIBS)
	mkdir bin
	$(CC) $(CFLAGS) --out-fmt-ihx -o $@ $(LDFLAGS) -llibstm8s.a $<
