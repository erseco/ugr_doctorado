###############################################################################
#
# PhD - Doctoral Project
# University of Granada
#
# Root Makefile orchestrating documentation builds
#
# Author: Ernesto Serrano <erseco@correo.ugr.es>
###############################################################################

ROOT_DIR := $(abspath .)
OUTPUT_DIR ?= $(ROOT_DIR)/output
ZOTERO_BIB_URL ?= https://api.zotero.org/groups/5784268/items/top?format=biblatex
BIB_FILE ?= $(ROOT_DIR)/bibliography/references.bib
SPELLCHECK ?= aspell
TOOLS_DIR ?= $(ROOT_DIR)/tools
TEXTIDOTE_JAR ?= $(TOOLS_DIR)/textidote.jar
TEXTIDOTE_LANG ?= es
TEXTIDOTE_OUTDIR ?= $(OUTPUT_DIR)/textidote

export ROOT_DIR OUTPUT_DIR ZOTERO_BIB_URL BIB_FILE SPELLCHECK

.PHONY: all bibliography thesis project papers slides clean lint update-bib \
	textidote textidote-thesis textidote-papers download-textidote \
	check-dependencies check-node check-r check-tectonic check-spellcheck \
	check-marp check-soffice help

.DEFAULT_GOAL := help

all: check-dependencies bibliography thesis project papers slides

bibliography update-bib:
	@$(MAKE) -C bibliography update

thesis:
	@$(MAKE) -C thesis pdf

project:
	@$(MAKE) -C project pdf

papers:
	@$(MAKE) -C papers pdf

slides:
	@$(MAKE) -C slides pdf

# Dependency checks
check-dependencies: check-r check-tectonic check-spellcheck check-marp

check-node:
	@command -v node >/dev/null 2>&1 || { echo "Error: Node.js is not installed."; exit 1; }
	@command -v npm >/dev/null 2>&1 || { echo "Error: npm is not installed."; exit 1; }

check-r:
	@command -v Rscript >/dev/null 2>&1 || { \
		echo "Error: R is not installed. Please install it."; \
		exit 1; \
	}

check-tectonic:
	@command -v tectonic >/dev/null 2>&1 || { \
		echo "Error: tectonic is not installed. Please install it."; \
		exit 1; \
	}

check-spellcheck:
	@command -v $(SPELLCHECK) >/dev/null 2>&1 || { \
		echo "Error: $(SPELLCHECK) is not installed. Please install it."; \
		exit 1; \
	}

check-marp:
	@command -v marp >/dev/null 2>&1 || { \
		echo "Error: marp is not installed. Please install it."; \
		exit 1; \
	}

check-soffice:
	@command -v soffice >/dev/null 2>&1 || { echo "ERROR: 'soffice' is not installed. Please install it."; \
		exit 1; \
	}

# Cleaning and linting
clean:
	@$(MAKE) -C thesis clean
	@$(MAKE) -C project clean
	@$(MAKE) -C papers clean
	@$(MAKE) -C slides clean
	@rm -rf $(OUTPUT_DIR)
	@echo "Repository cleaned"

lint:
	@$(MAKE) -C thesis lint

textidote: textidote-thesis textidote-papers

define ensure_textidote
	@if [ ! -f "$(TEXTIDOTE_JAR)" ]; then \
		echo "Error: TeXtidote not found at $(TEXTIDOTE_JAR)."; \
		echo "Download it with 'make download-textidote' or set TEXTIDOTE_JAR."; \
		exit 1; \
	fi
endef

download-textidote:
	@mkdir -p $(TOOLS_DIR)
	@curl -sSL https://github.com/sylvainhalle/textidote/releases/download/v0.8.3/textidote.jar -o $(TEXTIDOTE_JAR)
	@echo "TeXtidote downloaded to $(TEXTIDOTE_JAR)"

textidote-thesis:
	$(call ensure_textidote)
	@mkdir -p $(TEXTIDOTE_OUTDIR)
	@echo "Running TeXtidote on thesis/thesis.tex"
	@java -jar $(TEXTIDOTE_JAR) --check $(TEXTIDOTE_LANG) --read-all --output singleline --no-color thesis/thesis.tex \
	  > $(TEXTIDOTE_OUTDIR)/thesis.txt || true

textidote-papers:
	$(call ensure_textidote)
	@mkdir -p $(TEXTIDOTE_OUTDIR)/papers
	@if [ -n "$(shell find papers -type f -name '*.Rnw')" ]; then \
		echo "Analyzing LaTeX-based papers with TeXtidote"; \
		for src in $(shell find papers -type f -name '*.Rnw'); do \
			rel=$${src#papers/}; \
			out="$(TEXTIDOTE_OUTDIR)/papers/$${rel%.*}.txt"; \
			outdir=$$(dirname "$$out"); \
			mkdir -p "$$outdir"; \
			echo "  -> $$src"; \
			java -jar $(TEXTIDOTE_JAR) --check $(TEXTIDOTE_LANG) --read-all --output singleline --no-color "$$src" \
			  > "$$out" || true; \
		done; \
	else \
		echo "No .Rnw papers found for TeXtidote."; \
	fi
	@if [ -n "$(shell find papers -type f -name '*.Rmd')" ]; then \
		echo "Analyzing Markdown-based papers with TeXtidote"; \
		for src in $(shell find papers -type f -name '*.Rmd'); do \
			rel=$${src#papers/}; \
			out="$(TEXTIDOTE_OUTDIR)/papers/$${rel%.*}.txt"; \
			outdir=$$(dirname "$$out"); \
			mkdir -p "$$outdir"; \
			echo "  -> $$src"; \
			java -jar $(TEXTIDOTE_JAR) --type md --check $(TEXTIDOTE_LANG) --output singleline --no-color "$$src" \
			  > "$$out" || true; \
		done; \
	else \
		echo "No .Rmd papers found for TeXtidote."; \
	fi

help:
	@echo "Available commands:"
	@echo "  all           - Build bibliography, thesis, project, papers and slides"
	@echo "  bibliography  - Download bibliography from Zotero"
	@echo "  thesis        - Build the thesis PDF"
	@echo "  project       - Build the project deliverables"
	@echo "  papers        - Build PDFs for all papers"
	@echo "  slides        - Build slide decks"
	@echo "  lint          - Check LaTeX code style and spelling for the thesis"
	@echo "  textidote     - Run TeXtidote analysis on thesis and papers"
	@echo "  clean         - Remove generated artifacts"
	@echo ""
	@echo "Dependency helpers:"
	@echo "  check-node"
	@echo "  check-r"
	@echo "  check-tectonic"
	@echo "  check-spellcheck"
	@echo "  check-marp"
	@echo "  check-soffice"
	@echo ""
	@echo "Utilities:"
	@echo "  download-textidote - Fetch TeXtidote jar into tools/"
