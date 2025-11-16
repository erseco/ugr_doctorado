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

export ROOT_DIR OUTPUT_DIR ZOTERO_BIB_URL BIB_FILE SPELLCHECK

.PHONY: all bibliography thesis project papers slides clean lint update-bib \
	check-dependencies check-node check-r check-tectonic check-spellcheck \
	check-marp check-soffice help

.DEFAULT_GOAL := help

all: check-dependencies bibliography thesis project papers slides

bibliography update-bib:
	@$(MAKE) -C bibliography update

thesis:
	@$(MAKE) -C thesis pdf

project: check-node check-soffice
	@$(MAKE) -C project pdf

papers:
	@$(MAKE) -C papers pdf

slides: check-marp
	@$(MAKE) -C slides pdf
	@$(MAKE) -C slides site

serve: check-marp
	@$(MAKE) -C slides serve

# Dependency checks
check-dependencies: check-node check-r check-tectonic check-spellcheck

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

help:
	@echo "Available commands:"
	@echo "  all           - Build bibliography, thesis, project, papers and slides"
	@echo "  bibliography  - Download bibliography from Zotero"
	@echo "  thesis        - Build the thesis PDF"
	@echo "  project       - Build the project deliverables"
	@echo "  papers        - Build PDFs for all papers"
	@echo "  slides        - Build slide decks"
	@echo "  lint          - Check LaTeX code style and spelling for the thesis"
	@echo "  clean         - Remove generated artifacts"
	@echo ""
	@echo "Dependency helpers:"
	@echo "  check-node"
	@echo "  check-r"
	@echo "  check-tectonic"
	@echo "  check-spellcheck"
	@echo "  check-marp"
	@echo "  check-soffice"
