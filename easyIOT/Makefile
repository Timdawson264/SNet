
DEVICE_DESC = $(patsubst %.json,%.h,$(wildcard devices/*.json))


all: easyiot.h $(DEVICE_DESC)

easyiot.h : easyiot.fbs
	flatcc -ga $< --outfile $@        

%.bin : %.json
	flatc -b -o $(dir $<) device_description.fbs $<

%.h : %.bin
	xxd -i $< $@

clean:
	-rm -f $(DEVICE_DESC) $(patsubst %.h,%.bin, $(DEVICE_DESC) )
	-rm easyiot.h

.PHONY: all