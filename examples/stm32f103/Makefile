#
# Our project settings. Most of the settings below this block wont need to be
# changed, with the exception of adding some extra drivers to the STM32 section.
#
TARGET = stm32f103

SRCS_C = \
    main.c \
    hal/debug.c \
    hal/snet.c

INCLUDE = src src/hal

BUILD_DIR = build


#
# TODO: We'll tidy this bit up later
#
SNET_DIR ?= ../..

SNET_SRCS_C = \
    src/snet.c \
    src/util/printf.c \
    src/util/ringbuf.c

SNET_INCLUDE = \
    include \
    src/util

INCLUDE += $(addprefix $(SNET_DIR)/, $(SNET_INCLUDE))


#
# STM32 drivers
#
STM_DIR ?= cube

STM_SRCS_C = \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio_ex.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim_ex.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash_ex.c \
	Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_uart.c \
	Src/main.c \
	Src/stm32f1xx_hal_msp.c \
	Src/system_stm32f1xx.c

STM_SRCS_S = \
        startup_stm32f103xb.s

STM_INCLUDE = \
	Inc \
	Drivers/STM32F1xx_HAL_Driver/Inc \
	Drivers/CMSIS/Device/ST/STM32F1xx/Include \
	Drivers/CMSIS/Include

STM_DEFS = USE_HAL_DRIVER STM32F103xB

INCLUDE += $(addprefix $(STM_DIR)/, $(STM_INCLUDE))


#
# Compiler flags
#
CFLAGS += -mthumb -mcpu=cortex-m3 -mfloat-abi=soft
CFLAGS += $(addprefix -D, $(STM_DEFS))
CFLAGS += -std=c11 -Os -g3
CFLAGS += -ffunction-sections -fdata-sections -fno-builtin
CFLAGS += $(addprefix -I, $(INCLUDE))

# We'll only enable warnings on our code.
CFLAGS_WARN += -Wall -Werror -Wno-format

LFLAGS += -L$(STM_DIR) -TSTM32F103C8Tx_FLASH.ld
LFLAGS += --specs=nano.specs
LFLAGS += -lc -lnosys
LFLAGS += -Wl,--gc-sections -Wl,-Map=$(BUILD_DIR)/$(TARGET).map


OBJS = 	$(addprefix $(BUILD_DIR)/src/, $(SRCS_C:.c=.o)) \
	$(addprefix $(BUILD_DIR)/src/, $(SRCS_S:.s=.o)) \
	$(addprefix $(BUILD_DIR)/snet/, $(SNET_SRCS_C:.c=.o)) \
	$(addprefix $(BUILD_DIR)/vendor/, $(STM_SRCS_C:.c=.o)) \
	$(addprefix $(BUILD_DIR)/vendor/, $(STM_SRCS_S:.s=.o))


#
# Build rules
#
.PHONY: all clean prog

all: $(BUILD_DIR)/$(TARGET).elf

$(BUILD_DIR)/src/%.o: src/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) $(CFLAGS_WARN) -c -o $@

$(BUILD_DIR)/src/%.o: src/%.s
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) $(CFLAGS_WARN) -c -o $@

# TODO: We'll move this out too. We want SNet to build itself and then link into
# the example!
$(BUILD_DIR)/snet/%.o: $(SNET_DIR)/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -D__FILENAME__=\"$(subst $(SNET_DIR)/,,$<)\" -c -o $@

$(BUILD_DIR)/vendor/%.o: $(STM_DIR)/%.c
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -c -o $@

$(BUILD_DIR)/vendor/%.o: $(STM_DIR)/%.s
	$(MKDIR) -p $(dir $@)
	$(CC) $< $(CFLAGS) -c -o $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	$(MKDIR) -p $(dir $@)
	$(CC) $^ $(CFLAGS) $(LFLAGS) -o $@
	$(SIZE) $@

clean:
	rm -rf $(BUILD_DIR)


#
# TOOLCHAIN
#
CC=arm-none-eabi-gcc
GDB=arm-none-eabi-gdb
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
SIZE=arm-none-eabi-size
MKDIR=mkdir
