INKSCAPE=inkscape

INTERMEDIATES	+= intermediates/ticket_background.png

.PHONY: all
all: prepare

.PHONY: prepare
prepare: $(INTERMEDIATES)

intermediates:
	mkdir $@

intermediates/ticket_background.png: ticket_background.svg intermediates
	$(INKSCAPE) $< --export-png=$@ --export-dpi=600

clean:
	rm -fr $(INTERMEDIATES)
	rmdir intermediates/
