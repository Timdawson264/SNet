#ifndef PRINTF_H__
#define PRINTF_H__

#include <stdarg.h>


extern int
printf(const char *fmt, ...);


extern int
vprintf(const char *fmt, va_list args);


/**
 * Puts a character onto the debug interface. Internally, this is called by
 * printf and vprintf and must be provided as part of the BSP.
 *
 * @param ch the character to send.
 */
extern void
debug_putc(char ch);


#endif
