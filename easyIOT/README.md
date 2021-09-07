## This is a simple message protocol using nano proto buffers.

Inputs and outputs set using the FT_CALLBACK feature so we can do this as the message is decoded/encoded.



# Device Descriptor 
This describes a device including its inputs and outputs.
And what type of inputs and outputs.

These Device Descriptors are stored in the devices folder.
These are converted into headerfiles to be included into projects.


# Idea
The inputs or output do not need to be real physical pins.
an analogue output could be a set point for a pid controller.
and input could get the offset of said pid controller.
or a simple relay.