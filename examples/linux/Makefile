#
# Our project settings. Most of the settings below this block wont need to be
# changed, with the exception of adding some extra drivers to the STM32 section.
#
TARGET = linux

SRCS_C = \
    main.c \
    hal/snet.c

INCLUDE = src src/hal

BUILD_DIR = build


#
# SNet library sources.
#
SNET_DIR ?= ../..

SNET_SRCS_C = \
    src/snet.c \
    src/util/crc32.c \
    src/util/printf.c \
    src/util/rand.c \
    src/lwrb/lwrb/src/lwrb/lwrb.c

SNET_INCLUDE = src src/util src/lwrb/lwrb/src/include
INCLUDE += $(addprefix $(SNET_DIR)/, $(SNET_INCLUDE))

#
# Compiler flags
#
CFLAGS += -Os -g3 -flto -MMD -DSNET_DEBUG
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += $(addprefix -I, $(INCLUDE))

# We'll only enable warnings on our code.
CFLAGS_WARN += -Wall -Werror -Wno-format

LFLAGS += -flto -lpthread -lserialport
LFLAGS += -Wl,--gc-sections -Wl,-Map=$(BUILD_DIR)/$(TARGET).map

OBJS = $(addprefix $(BUILD_DIR)/src/, $(SRCS_C:.c=.o)) \
	$(addprefix $(BUILD_DIR)/src/, $(SRCS_S:.s=.o)) \
	$(addprefix $(BUILD_DIR)/snet/, $(SNET_SRCS_C:.c=.o)) \
	$(addprefix $(BUILD_DIR)/vendor/, $(STM_SRCS_C:.c=.o)) \
	$(addprefix $(BUILD_DIR)/vendor/, $(STM_SRCS_S:.s=.o))

DEPS = $(addprefix $(BUILD_DIR)/src/, $(SRCS_C:.c=.d)) \
	$(addprefix $(BUILD_DIR)/snet/, $(SNET_SRCS_C:.c=.d)) \
	$(addprefix $(BUILD_DIR)/vendor/, $(STM_SRCS_C:.c=.d))
#
# Build rules
#
.PHONY: all clean flash

all: $(BUILD_DIR)/$(TARGET)

-include $(DEPS)
$(BUILD_DIR)/src/%.o: src/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) $(CFLAGS_WARN) -c -o $@

$(BUILD_DIR)/src/%.o: src/%.s
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) $(CFLAGS_WARN) -c -o $@

# TODO: We'll move this out too. We want SNet to build itself and then link into
# the example!
-include $(DEPS)
$(BUILD_DIR)/snet/%.o: $(SNET_DIR)/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -D__FILENAME__=\"$(subst $(SNET_DIR)/,,$<)\" -c -o $@

-include $(DEPS)
$(BUILD_DIR)/vendor/%.o: $(STM_DIR)/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -c -o $@

$(BUILD_DIR)/vendor/%.o: $(STM_DIR)/%.s
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -c -o $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/$(TARGET): $(OBJS)
	$(MKDIR) -p $(dir $@)
	$(CC) $^ $(CFLAGS) $(LFLAGS) -o $@
	$(SIZE) $@

clean:
	rm -rf $(BUILD_DIR)

#
# TOOLCHAIN
#
CC=gcc
GDB=gdb
OBJCOPY=objcopy
OBJDUMP=objdump
SIZE=size
MKDIR=mkdir
