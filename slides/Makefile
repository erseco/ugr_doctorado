ROOT_DIR ?= $(abspath ..)
OUTPUT_DIR ?= $(ROOT_DIR)/output
SLIDES_OUTPUT_DIR := $(OUTPUT_DIR)/slides
SLIDES_SRC := $(wildcard *.md)
SLIDES_HTML := $(patsubst %.md,$(SLIDES_OUTPUT_DIR)/%.html,$(SLIDES_SRC))
SLIDES_PDF := $(patsubst %.md,$(SLIDES_OUTPUT_DIR)/%.pdf,$(SLIDES_SRC))
ASSETS_SRC := $(ROOT_DIR)/images
ASSETS_OUTPUT_DIR := $(OUTPUT_DIR)/images
SITE_DIR := $(OUTPUT_DIR)/site
SITE_SLIDES_DIR := $(SITE_DIR)/slides
INDEX_HTML := $(SITE_DIR)/index.html
INDEX_SCRIPT := $(ROOT_DIR)/slides/scripts/generate-index.js

MARP := $(shell command -v marp 2>/dev/null)

.PHONY: pdf html site stage-site clean prepare assets check-marp serve
.DEFAULT_GOAL := pdf

pdf: html $(SLIDES_PDF)
	@echo "Slides (HTML+PDF) available in $(SLIDES_OUTPUT_DIR)"

html: check-marp prepare assets $(SLIDES_HTML)
	@echo "HTML slides available in $(SLIDES_OUTPUT_DIR)"

site: html
	@$(MAKE) stage-site
	@if [ -f "$(INDEX_SCRIPT)" ]; then \
		node "$(INDEX_SCRIPT)" "$(SITE_SLIDES_DIR)" "$(INDEX_HTML)"; \
	else \
		echo "Warning: $(INDEX_SCRIPT) not found. Skipping index generation."; \
	fi
	@echo "Slide site staged at $(SITE_DIR)"

prepare:
	@mkdir -p $(SLIDES_OUTPUT_DIR)

assets: prepare
	@if [ -d "$(ASSETS_SRC)" ]; then \
		mkdir -p "$(ASSETS_OUTPUT_DIR)"; \
		rsync -a --delete "$(ASSETS_SRC)/" "$(ASSETS_OUTPUT_DIR)/"; \
		mkdir -p "$(SLIDES_OUTPUT_DIR)"; \
		ln -sfn ../images "$(SLIDES_OUTPUT_DIR)/images"; \
		ln -sfn ../images/assets "$(SLIDES_OUTPUT_DIR)/assets"; \
	fi

# 		ln -sfn ../images "$(ROOT_DIR)/images"; \
# 		ln -sfn ../images/assets "$(ROOT_DIR)/assets"; \


$(SLIDES_OUTPUT_DIR)/%.html: %.md | prepare assets
	@echo "Building HTML: $<"
	@marp --html --theme-set themes/ --allow-local-files --base-dir "$(ROOT_DIR)" $< -o $@

$(SLIDES_OUTPUT_DIR)/%.pdf: %.md | prepare assets
	@echo "Building PDF: $<"
	@marp --html --theme-set themes/ --allow-local-files --base-dir "$(ROOT_DIR)" --pdf $< -o $@

serve: assets
	marp --server --watch --allow-local-files --input-dir . --base-dir "$(ROOT_DIR)"

check-marp:
ifndef MARP
	$(error "marp not found. Please install with: npm install -g @marp-team/marp-cli")
endif

stage-site:
	@mkdir -p "$(SITE_SLIDES_DIR)"
	@rsync -a --delete "$(SLIDES_OUTPUT_DIR)/" "$(SITE_SLIDES_DIR)/"
	@if [ -d "$(ASSETS_OUTPUT_DIR)" ]; then \
		mkdir -p "$(SITE_DIR)/images"; \
		rsync -a --delete "$(ASSETS_OUTPUT_DIR)/" "$(SITE_DIR)/images/"; \
	fi

clean:
	@rm -rf $(SLIDES_OUTPUT_DIR)
	@rm -rf $(ASSETS_OUTPUT_DIR)
	@rm -rf $(SITE_DIR)
	@echo "Slide outputs removed"
