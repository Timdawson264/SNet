## This is a simple message protocol using flatbuffers.

# Device Descriptor 
This describes a device including its inputs and outputs.
And what type of inputs and outputs.


# Idea
The inputs or output do not need to be real physical pins.
an analogue output could be a set point for a pid controller.
and input could get the offset of said pid controller.
or a simple relay.