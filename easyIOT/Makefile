
#include ~/Downloads/nanopb-0.4.5-macosx-x86/extra/nanopb.mk

#DEVICE_DESC = $(patsubst %.json,%.h,$(wildcard devices/*.json))

PROTOC=/Users/tim/Downloads/nanopb-0.4.5-macosx-x86/generator-bin/protoc


all: easyiot.pb.h easyiot.pb.c

easyiot.pb.h easyiot.pb.c: easyiot.proto
	$(PROTOC)  --nanopb_out=.  $<        

#%.bin : %.json
#	flatc -b -o $(dir $<) device_description.fbs $<

#%.h : %.bin
#	xxd -i $< $@

clean:
	-rm -f $(DEVICE_DESC) $(patsubst %.h,%.bin, $(DEVICE_DESC) )
	-rm easyiot.h

.PHONY: all
