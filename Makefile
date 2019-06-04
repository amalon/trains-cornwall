INKSCAPE	:= inkscape
CONVERT		:= convert
PDFPOSTER	:= pdfposter

TMP		:= intermediates
OUT		:= outputs

DPIS		:= 75 150 300

OUTDIRS		+= $(TMP)
OUTDIRS		+= $(OUT)

INTERMEDIATES	+= $(TMP)/ticket_background.png

PNG_OUTPUTS	+= $(foreach dpi,$(DPIS),$(OUT)/Cornwall-$(dpi)dpi.png)
PDF_OUTPUTS	+= $(foreach dpi,$(DPIS),$(OUT)/Cornwall-$(dpi)dpi.pdf)
TILED_OUTPUTS	+= $(foreach pdf,$(PDF_OUTPUTS),$(pdf:.pdf=-a4.pdf))

OUTPUTS		+= $(PNG_OUTPUTS)
OUTPUTS		+= $(PDF_OUTPUTS)
OUTPUTS		+= $(TILED_OUTPUTS)

DEFAULT_OUTPUTS	+= $(OUT)/Cornwall-300dpi-a4.pdf

.PHONY: default
default: $(DEFAULT_OPTIONS)

.PHONY: all
all: prepare $(OUTPUTS)

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
	$(INKSCAPE) $< --export-png=$@.tmp --export-dpi=600
	mv $@.tmp $@

$(PNG_OUTPUTS): $(OUT)/Cornwall-%dpi.png: Cornwall.svg | $(OUT)
	rm -f $@
	$(INKSCAPE) $< --export-png=$@.tmp --export-dpi=$(@:$(OUT)/Cornwall-%dpi.png=%)
	mv $@.tmp $@

$(PDF_OUTPUTS): $(OUT)/Cornwall%.pdf: $(OUT)/Cornwall%.png
	rm -f $@
	$(CONVERT) $< $@.tmp.pdf
	mv $@.tmp.pdf $@

$(TILED_OUTPUTS): %-a4.pdf: %.pdf
	rm -f $@
	$(PDFPOSTER) -m27x19cm -s1 $< $@.tmp
	mv $@.tmp $@

clean:
	rm -f $(INTERMEDIATES)
	rm -f $(PNG_OUTPUTS)
	rm -f $(PDF_OUTPUTS)
	rm -f $(TILED_OUTPUTS)
	rm -f $(OUT)/*.tmp
	rmdir $(OUTDIRS) || true
