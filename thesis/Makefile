ROOT_DIR ?= $(abspath ..)
OUTPUT_DIR ?= $(ROOT_DIR)/output
SPELLCHECK ?= aspell

CHAPTERS_DIR := chapters
THESIS_TEX := thesis.tex
CHAPTERS_RNW := $(wildcard $(CHAPTERS_DIR)/*.Rnw)
CHAPTERS_TEX := $(patsubst $(CHAPTERS_DIR)/%.Rnw,$(CHAPTERS_DIR)/%.tex,$(CHAPTERS_RNW))
THESIS_PDF := $(OUTPUT_DIR)/thesis.pdf

.PHONY: pdf convert clean clean-generated lint prepare
.DEFAULT_GOAL := pdf

pdf: prepare convert $(THESIS_PDF) clean-generated

convert: $(CHAPTERS_TEX)
	@echo "All chapters converted to .tex."
	@if [ -d $(CHAPTERS_DIR)/figure ]; then \
		echo "Consolidating chapter figures..."; \
		rm -rf figure; \
		mv $(CHAPTERS_DIR)/figure ./; \
	fi

$(CHAPTERS_DIR)/%.tex: $(CHAPTERS_DIR)/%.Rnw
	@echo "Knitting $<"
	@Rscript -e "setwd('$(dir $<)'); knitr::knit('$(notdir $<)')"

$(THESIS_PDF): $(THESIS_TEX) $(CHAPTERS_TEX)
	@mkdir -p $(OUTPUT_DIR)
	@echo "Compiling thesis with Tectonic..."
	@tectonic $(THESIS_TEX)
	@mv $(basename $(THESIS_TEX)).pdf $(THESIS_PDF)
	@echo "Thesis compiled: $(THESIS_PDF)"

clean-generated:
	@rm -f $(CHAPTERS_TEX)
	@rm -rf figure
	@rm -rf $(CHAPTERS_DIR)/figure

clean: clean-generated
	@rm -f $(THESIS_PDF)
	@echo "Thesis artifacts removed"

lint:
	@echo "Checking LaTeX spelling in chapters..."
	@find . -name "*.tex" -exec $(SPELLCHECK) --lang=en --mode=tex check {} \;

prepare:
	@mkdir -p $(OUTPUT_DIR)
