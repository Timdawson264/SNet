
#include "crc32.h"

uint32_t
snet_crc32_bitwise(const uint8_t* data, uint16_t length)
{
const uint32_t Polynomial = 0xEDB88320;
  uint32_t crc = 0xFFFFFFFF; // same as previousCrc32 ^ 0xFFFFFFFF
  const uint8_t* current = (const uint8_t*) data;

  while (length-- != 0)
  {
    crc ^= *current++;

    for (int j = 0; j < 8; j++)
    {
      // branch-free
      //if crc&1 then mask on the poly, else mask poly off and ^0
      crc = (crc >> 1) ^ ( ((int32_t) -(crc & 1)) & Polynomial);
    }
  }

  return ~crc; // same as crc ^ 0xFFFFFFFF
}

