ROOT_DIR ?= $(abspath ..)
OUTPUT_DIR ?= $(ROOT_DIR)/output
SLIDES_OUTPUT_DIR := $(OUTPUT_DIR)/slides
SLIDES_SRC := $(wildcard *.md)
SLIDES_PDF := $(patsubst %.md,$(SLIDES_OUTPUT_DIR)/%.pdf,$(SLIDES_SRC))

MARP := $(shell command -v marp 2>/dev/null)

.PHONY: pdf clean prepare check-marp
.DEFAULT_GOAL := pdf

pdf: check-marp prepare $(SLIDES_PDF)
	@echo "Slides available in $(SLIDES_OUTPUT_DIR)"

prepare:
	@mkdir -p $(SLIDES_OUTPUT_DIR)

$(SLIDES_OUTPUT_DIR)/%.pdf: %.md
	@mkdir -p $(dir $@)
	@marp $< -o $@
	@echo "Slide compiled: $@"

check-marp:
ifndef MARP
	$(error "marp not found. Please install with: npm install -g @marp-team/marp-cli")
endif

clean:
	@rm -rf $(SLIDES_OUTPUT_DIR)
	@echo "Slide outputs removed"
