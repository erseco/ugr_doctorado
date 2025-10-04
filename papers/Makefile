ROOT_DIR ?= $(abspath ..)
OUTPUT_DIR ?= $(ROOT_DIR)/output
PAPERS_OUTPUT_DIR := $(OUTPUT_DIR)/papers

RNW_SOURCES_RAW := $(shell find . -type f -name '*.Rnw')
RMD_SOURCES_RAW := $(shell find . -type f -name '*.Rmd')
RNW_SOURCES := $(patsubst ./%,%,$(RNW_SOURCES_RAW))
RMD_SOURCES := $(patsubst ./%,%,$(RMD_SOURCES_RAW))
RNW_OUT := $(patsubst %.Rnw,$(PAPERS_OUTPUT_DIR)/%.pdf,$(RNW_SOURCES))
RMD_OUT := $(patsubst %.Rmd,$(PAPERS_OUTPUT_DIR)/%.pdf,$(RMD_SOURCES))
RNW_TEX := $(patsubst %.Rnw,%.tex,$(RNW_SOURCES))
RMD_TEX := $(patsubst %.Rmd,%.tex,$(RMD_SOURCES))
RNW_LOCAL_PDF := $(patsubst %.Rnw,%.pdf,$(RNW_SOURCES))
RMD_LOCAL_PDF := $(patsubst %.Rmd,%.pdf,$(RMD_SOURCES))

.PHONY: pdf clean prepare
.DEFAULT_GOAL := pdf

pdf: prepare $(RNW_OUT) $(RMD_OUT)
	@echo "Paper outputs available in $(PAPERS_OUTPUT_DIR)"

prepare:
	@mkdir -p $(PAPERS_OUTPUT_DIR)

$(PAPERS_OUTPUT_DIR)/%.pdf: %.Rnw
	@mkdir -p $(dir $@)
	@echo "Knitting $<"
	@Rscript -e "setwd('$(dir $<)'); knitr::knit('$(notdir $<)')"
	@dir="$(dir $<)"; \
	base="$(notdir $<)"; \
	stem="$${base%.*}"; \
	tex_path="$$dir$$stem.tex"; \
	echo "Compiling $$tex_path with Tectonic"; \
	tectonic --outdir "$(dir $@)" "$$tex_path"; \
	rm -f "$$tex_path"
	@rm -rf "$(dir $<)figure"

$(PAPERS_OUTPUT_DIR)/%.pdf: %.Rmd
	@mkdir -p $(dir $@)
	@echo "Rendering $< with rmarkdown"
	@Rscript -e "rmarkdown::render('$<', output_file='$(notdir $@)', output_format=rmarkdown::pdf_document(latex_engine='tectonic'), quiet=FALSE)" || { \
		echo 'Error: Failed to compile $<'; \
		exit 1; \
	}
	@mv "$(dir $<)$(notdir $@)" "$@"

clean:
	@rm -f $(RNW_TEX) $(RMD_TEX) $(RNW_LOCAL_PDF) $(RMD_LOCAL_PDF)
	@rm -rf $(PAPERS_OUTPUT_DIR)
	@find . -type d -name 'figure' -exec rm -rf {} +
	@echo "Paper artifacts removed"
