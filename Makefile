INKSCAPE	:= inkscape
CONVERT		:= convert
PDFPOSTER	:= pdfposter

TMP		:= intermediates
OUT		:= outputs

DPIS		:= 75 150 300
DPI		?= 300

OUTDIRS		+= $(TMP)
OUTDIRS		+= $(OUT)

PNG_OUTPUTS	+= $(foreach dpi,$(DPIS),$(OUT)/Cornwall-$(dpi)dpi.png)
PDF_OUTPUTS	+= $(foreach dpi,$(DPIS),$(OUT)/Cornwall-$(dpi)dpi.pdf)
TILED_OUTPUTS	+= $(foreach pdf,$(PDF_OUTPUTS),$(pdf:.pdf=-a4.pdf))

BOARD_OUTPUTS	:= $(TILED_OUTPUTS)
BOARD_DEFAULT	:= $(OUT)/Cornwall-$(DPI)dpi-a4.pdf


INTERMEDIATES	+= $(TMP)/ticket_background.png

PAGES		:= $(shell grep 'inkscape:label="Page [0-9]\+"' cornwall_tickets.svg | \
			   sed 's/^.*Page \([0-9]\+\).*$$/\1/')
SVG_TICKETS	+= $(foreach page,$(PAGES),$(TMP)/cornwall_tickets.page$(page).svg)
PNG_TICKETS	+= $(foreach page,$(PAGES),$(TMP)/cornwall_tickets.page$(page)-$(DPI)dpi.png)

TICKET_OUTPUTS	:= $(OUT)/cornwall_tickets-$(DPI)dpi.pdf


OUTPUTS		+= $(BOARD_OUTPUTS)
OUTPUTS		+= $(TICKET_OUTPUTS)

.PHONY: default
default: board tickets

.PHONY: all
all: prepare $(OUTPUTS)

.PHONY: board
board: $(BOARD_DEFAULT)

.PHONY: tickets
tickets: $(TICKET_OUTPUTS)

.PHONY: png
png: $(PNG_OUTPUTS)

.PHONY: pdf
pdf: $(PDF_OUTPUTS) $(TILED_OUTPUTS)

.PHONY: prepare
prepare: $(INTERMEDIATES)

$(OUTDIRS):
	mkdir $@

$(INTERMEDIATES): $(TMP)/%.png: %.svg | $(TMP)
	rm -f $@
	$(INKSCAPE) $< -o $@-tmp.png --export-dpi=300
	mv $@-tmp.png $@

$(PNG_OUTPUTS): $(OUT)/Cornwall-%dpi.png: Cornwall.svg | $(OUT)
	rm -f $@
	$(INKSCAPE) $< -o $@-tmp.png --export-dpi=$(@:$(OUT)/Cornwall-%dpi.png=%)
	mv $@-tmp.png $@

$(PDF_OUTPUTS): %.pdf: %.png
	rm -f $@
	$(CONVERT) $< $@.tmp.pdf
	mv $@.tmp.pdf $@

$(TILED_OUTPUTS): %-a4.pdf: %.pdf
	rm -f $@
	$(PDFPOSTER) -m27x19cm -s1 $< $@.tmp
	mv $@.tmp $@

$(SVG_TICKETS): cornwall_tickets.svg | $(TMP)
	rm -f $@
	cp cornwall_tickets.svg $@.tmp
	sed -i '/inkscape:label="Page [0-9]\+"/{N;N;N;/style=/{s/style="display:inline"/style="display:none"/}}' $@.tmp
	sed -i '/inkscape:label="Page $(patsubst $(TMP)/cornwall_tickets.page%.svg,%,$@)"/{N;N;N;/style=/{s/style="display:none"/style="display:inline"/}}' $@.tmp
	mv $@.tmp $@

# This symlink is required due to links in the ticket SVG which we have
# intermediate versions of in the temp directory.
$(TMP)/$(TMP):
	ln -s . $(TMP)/$(TMP)

$(PNG_TICKETS): %-$(DPI)dpi.png: %.svg $(TMP)/ticket_background.png $(TMP)/$(TMP)
	rm -f $@
	$(INKSCAPE) $< -o $@-tmp.png --export-dpi=$(DPI)
	mv $@-tmp.png $@

$(TICKET_OUTPUTS): $(PNG_TICKETS) | $(OUT)
	rm -f $@
	$(CONVERT) $^ $@.tmp.pdf
	mv $@.tmp.pdf $@

clean:
	rm -f $(INTERMEDIATES)
	rm -f $(PNG_OUTPUTS)
	rm -f $(PDF_OUTPUTS)
	rm -f $(TILED_OUTPUTS)
	rm -f $(SVG_TICKETS)
	rm -f $(PNG_TICKETS)
	rm -f $(OUTPUTS)
	rm -f $(TMP)/*.tmp
	rm -f $(OUT)/*.tmp
	rmdir $(OUTDIRS) || true
