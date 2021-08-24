
DEVICE_DESC = $(patsubst %.json,%.h,$(wildcard *.json))


all: easyiot.h $(DEVICE_DESC)

easyiot.h : easyiot.fbs
	flatcc -ga $< --outfile $@        

%.bin : %.json
	flatc -b device_description.fbs $<

%.h : %.bin
	xxd -i $< $@

clean:
	-rm -f $(DEVICE_DESC) $(patsubst %.h,%.bin, $(DEVICE_DESC) )
	-rm easyiot.h

.PHONY: all