#include <string.h>
#include <stdbool.h>

#include "printf.h"


#define MAX_INTEGER_LENGTH (16)
static int
print_int_unsigned(char *buf,
		   unsigned int value,
		   unsigned int base,
		   unsigned int width,
		   char pad,
		   char sign,
		   bool right_align)
{
    unsigned int length = 0;
    unsigned int i = 0, j, n;
    char tmp[MAX_INTEGER_LENGTH];

    /* Default padding is spaces. */
    if (pad == 0)
    {
	pad = ' ';
    }

    /* Figure out how many characters we'll need to print. */
    if (value == 0)
    {
	length = 1;
    }
    else
    {
	n = value;
	while (n > 0)
	{
	    length++;
	    n /= base;
	}
    }

    /* Sort the padding */
    if (right_align && length < width)
    {
	for (j = 0; j < width - length; j++)
	{
	    buf[i++] = pad;
	}
    }

    /* Add the sign */
    if (sign)
    {
	buf[i++] = sign;
    }

    /* Print out the numerals. */
    if (value == 0)
    {
	buf[i++] = '0';
    }
    else
    {
	/* Stack all the numerals because the math works better (i.e. we add the
	 * right-most numeral first). */
	for (j = 0; value > 0; j++)
	{
	    n = value % base;
	    value /= base;

	    if (n <= 9)
	    {
		tmp[j] = '0' + n;
	    }
	    else
	    {
		tmp[j] = 'a' + n;
	    }
	}

	/* Unstack the numerals. */
	for (; j > 0; j--)
	{
	    buf[i++] = tmp[j-1];
	}
    }

    /* Add any padding if we're left-aligned. */
    if (!right_align && length < width)
    {
	for (j = 0; j < width - length; j++)
	{
	    buf[i++] = pad;
	}
    }

    return i;
}


static int
print_int(char *buf,
	  int value,
	  unsigned int base,
	  unsigned int width,
	  char pad,
	  int right_align)
{
    if (value >= 0)
    {
	return print_int_unsigned(buf,
				  value,
				  base,
				  width,
				  pad,
				  0,
				  right_align);
    }
    else
    {
	return print_int_unsigned(buf,
				  -value,
				  base,
				  width,
				  pad,
				  '-',
				  right_align);
    }
}


int
vprintf(const char *fmt, va_list args)
{
    bool right_align;
    char pad;
    unsigned int width;

    char buf[256];
    int i = 0, j;

    while (*fmt)
    {
	if (*fmt != '%')
	{
	    buf[i++] = *fmt++;
	}
	else
	{
	    fmt++;

	    /* Figure out if we need to right-align. */
	    right_align = true;
	    if (*fmt == '-')
	    {
		right_align = false;
		fmt++;
	    }

	    /* Figure out our padding. */
	    pad = 0;
	    if (*fmt == ' ' || *fmt == '0')
	    {
		pad = *fmt;
		fmt++;
	    }

	    /* Figure out our width. */
	    width = 0;
	    while (*fmt >= '0' && *fmt <= '9')
	    {
		width *= 10;
		width += *fmt - '0';
		fmt++;
	    }

	    /* Handle the format character. */
	    switch (*fmt++)
	    {
	    case 'd':
	    case 'i':
	    {
		int value = va_arg(args, int);
		i += print_int(&buf[i], value, 10, width, pad, right_align);
		break;
	    }

	    case 'u':
	    {
		int value = va_arg(args, unsigned);
		i += print_int_unsigned(&buf[i], value, 10, width, pad, 0,
                                        right_align);
		break;
	    }

	    case 'x':
	    case 'X':
	    {
		int value = va_arg(args, unsigned);
		i += print_int_unsigned(
		    &buf[i], value, 16, width, pad, 0, right_align);
		break;
	    }

	    case 'p':
	    {
		int value = va_arg(args, unsigned);
		i += print_int_unsigned(&buf[i], value, 10, 8, 0, 0, true);
		break;
	    }

	    case 'c':
	    {
		int c = va_arg(args, int);
		buf[i++] = c & 0xff;
		break;
	    }

	    case 's':
	    {
		const char *s = va_arg(args, const char *);
		while (*s)
		{
		    buf[i++] = *s++;
		}
		break;
	    }

	    case 'r':
	    {
		const unsigned char *bytes =
                    va_arg(args, const unsigned char *);

		unsigned int length = va_arg(args, unsigned);
		while (length--)
		{
		    i += print_int_unsigned(&buf[i], *bytes++, 16, 2, '0',
                                            0, true);

		    /* If there's space padding, then we'll separate
                     * octets. */
		    if (pad == ' ' && length > 0)
		    {
			buf[i++] = ' ';
		    }
		}
	    }

	    case '%':
	    {
		buf[i++] = '%';
		break;
	    }

	    default:
		break;
	    }
	}
    }

    for (j = 0; j < i; j++)
    {
	debug_putc(buf[j]);
    }

    return i;
}


int
printf(const char *fmt, ...)
{
    va_list args;
    unsigned int output;

    va_start(args, fmt);
    output = vprintf(fmt, args);
    va_end(args);

    return output;
}
