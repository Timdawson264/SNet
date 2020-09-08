TARGET = STM8S103

SRCS_C = \
    main.c \
    snet_hal.c \
    systick.c

INCLUDE = src

BUILD_DIR = build

#
# SNet library sources.
#
SNET_DIR ?= ../..

SNET_SRCS_C = \
    src/snet.c \
    src/util/crc32.c \
    src/util/ringbuf.c \
	src/util/rand.c

SNET_INCLUDE = src src/util

INCLUDE += $(addprefix $(SNET_DIR)/, $(SNET_INCLUDE))

#
# STM8 drivers
#
STM_DIR ?= libstm8s

STM_SRCS_C = \
	src/stm8s_clk.c \
	src/stm8s_gpio.c \
	src/stm8s_i2c.c \
	src/stm8s_uart1.c \
	src/stm8s_exti.c \
	src/stm8s_flash.c \
	src/stm8s_flash.c \
	src/stm8s_tim1.c \
	src/stm8s_tim2.c \
	src/stm8s_tim4.c 

STM_INCLUDE = inc

INCLUDE += $(addprefix $(STM_DIR)/, $(STM_INCLUDE))



CFLAGS += $(XCFLAGS)
CFLAGS += -D$(TARGET) -mstm8
CFLAGS += --Werror --opt-code-size -MMD
CFLAGS += --std-sdcc99
CFLAGS += $(addprefix -I, $(INCLUDE))
#CFLAGS_WARN += --Werror 

LFLAGS += -L ./build -lall.a

OBJS = 	$(addprefix $(BUILD_DIR)/src/, $(SRCS_C:.c=.rel) ) \
		$(addprefix $(BUILD_DIR)/snet/, $(SNET_SRCS_C:.c=.rel) ) \
		$(addprefix $(BUILD_DIR)/vendor/, $(STM_SRCS_C:.c=.rel) )

ALL_D = $(OBJS:.rel=.d)

all: $(BUILD_DIR)/$(TARGET).ihx

clean:
	-rm -rf build

-include $(ALL_D)
$(BUILD_DIR)/src/%.rel: src/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) $(CFLAGS_WARN) -c -o $@

-include $(ALL_D)
$(BUILD_DIR)/snet/%.rel: $(SNET_DIR)/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -D__FILENAME__=\"$(subst $(SNET_DIR)/,,$<)\" -c -o $@

-include $(ALL_D)
$(BUILD_DIR)/vendor/%.rel: $(STM_DIR)/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -c -o $@

#Compile all Objects into a Lib first
$(BUILD_DIR)/all.a: $(OBJS)
	$(MKDIR) -p $(dir $@)
	$(AR) r $@ $^

#Link all with the main.rel
$(BUILD_DIR)/$(TARGET).ihx: build/src/main.rel build/all.a
	$(MKDIR) -p $(dir $@)
	$(CC) $(CFLAGS) $(LFLAGS) --out-fmt-ihx -o $@ $< 

flash: $(BUILD_DIR)/$(TARGET).ihx
	stm8flash -c stlinkv2 -w $< -p stm8s103f3

.PHONY: clean flash all

#
# TOOLCHAIN
#
CC=~/Downloads/sdcc-4.0.0/bin/sdcc
AR=~/Downloads/sdcc-4.0.0/bin/sdar
OBJCOPY=~/Downloads/sdcc-4.0.0/bin/sdobjcopy
MKDIR=mkdir