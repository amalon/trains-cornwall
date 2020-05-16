INKSCAPE	:= inkscape
CONVERT		:= convert
PDFPOSTER	:= pdfposter
PDFLATEX	:= pdflatex

TMP		:= intermediates
OUT		:= outputs

DPIS		:= 75 150 300
DPI		?= 300

OUTDIRS		+= $(TMP)
OUTDIRS		+= $(OUT)

BOARD_SVG	:= Cornwall.svg
PNG_OUTPUTS	+= $(foreach dpi,$(DPIS),$(OUT)/Cornwall-$(dpi)dpi.png)
PDF_OUTPUTS	+= $(foreach dpi,$(DPIS),$(OUT)/Cornwall-$(dpi)dpi.pdf)
TILED_NOMARG	+= $(foreach dpi,$(DPIS),$(TMP)/Cornwall-$(dpi)dpi-a4-tight.pdf)
TILED_TEX	+= $(foreach dpi,$(DPIS),$(TMP)/Cornwall-$(dpi)dpi-a4.tex)
TILED_TMPOUT	+= $(foreach dpi,$(DPIS),$(TMP)/Cornwall-$(dpi)dpi-a4.pdf)
TILED_OUTPUTS	+= $(foreach dpi,$(DPIS),$(OUT)/Cornwall-$(dpi)dpi-a4.pdf)

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


# Perform some arithmetic using bc to calculate tile sizes
bc		= $(shell echo "$(1)" | bc)
bc_fp		= $(call bc,scale=10; $(1))
# Poster size can be taken straight from SVG
POSTER_WIDTH	:= $(shell grep -m1 width= "$(BOARD_SVG)" | sed 's/^.*"\(.*\)mm".*$$/\1/')
POSTER_HEIGHT	:= $(shell grep -m1 height= "$(BOARD_SVG)" | sed 's/^.*"\(.*\)mm".*$$/\1/')
# Tile based on size of A4 (landscape) subtracting margins
MAX_TILE_WIDTH	= (297-10-15)
MAX_TILE_HEIGHT	= (210-10-10)
TILES_X		:= $(call bc,($(POSTER_WIDTH)+$(MAX_TILE_WIDTH)-1) / $(MAX_TILE_WIDTH))
TILES_Y		:= $(call bc,($(POSTER_HEIGHT)+$(MAX_TILE_HEIGHT)-1) / $(MAX_TILE_HEIGHT))
# Find actual tile size
TILE_WIDTH	:= $(call bc_fp,$(POSTER_WIDTH) / $(TILES_X))
TILE_HEIGHT	:= $(call bc_fp,$(POSTER_HEIGHT) / $(TILES_Y))


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

$(PNG_OUTPUTS): $(OUT)/Cornwall-%dpi.png: $(BOARD_SVG) | $(OUT)
	rm -f $@
	$(INKSCAPE) $< -o $@-tmp.png --export-dpi=$(@:$(OUT)/Cornwall-%dpi.png=%)
	mv $@-tmp.png $@

$(PDF_OUTPUTS): %.pdf: %.png
	rm -f $@
	$(CONVERT) $< $@.tmp.pdf
	mv $@.tmp.pdf $@

$(TILED_TEX): %-a4.tex: margins-a4.tex
	rm -f $@
	sed -e 's/_TILE_WIDTH_/$(TILE_WIDTH)/' \
	    -e 's/_TILE_HEIGHT_/$(TILE_HEIGHT)/' \
	    -e 's/_SRC_/$(subst /,\/,$(@:%.tex=%-tight.pdf))/' $< > $@.tmp
	mv $@.tmp $@

$(TILED_NOMARG): $(TMP)/%-a4-tight.pdf: $(OUT)/%.pdf
	rm -f $@
	$(PDFPOSTER) -m$(TILE_WIDTH)x$(TILE_HEIGHT)mm -p$(POSTER_WIDTH)x$(POSTER_HEIGHT)mm $< $@.tmp
	mv $@.tmp $@

$(TILED_TMPOUT): %-a4.pdf: %-a4.tex %-a4-tight.pdf
	$(PDFLATEX) -output-directory=$(TMP) $<

$(TILED_OUTPUTS): $(OUT)/%: $(TMP)/%
	cp $< $@

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
