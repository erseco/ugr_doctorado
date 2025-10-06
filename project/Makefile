ROOT_DIR ?= $(abspath ..)
OUTPUT_DIR ?= $(ROOT_DIR)/output
PROJECT_OUTPUT_DIR := $(OUTPUT_DIR)/project
BIB_FILE ?= $(ROOT_DIR)/bibliography/references.bib
RUNNODE ?= node
GENERATOR := generate.js
PROJECT_TEMPLATE := project_template.docx
DATA_FILE := data.json
DOCX_OUT := $(PROJECT_OUTPUT_DIR)/project.docx
PDF_OUT := $(PROJECT_OUTPUT_DIR)/project.pdf

.PHONY: pdf clean prepare deps
.DEFAULT_GOAL := pdf

pdf: prepare deps $(PDF_OUT)
	@echo "Project files generated in $(PROJECT_OUTPUT_DIR)"

$(PDF_OUT): $(GENERATOR) $(PROJECT_TEMPLATE) $(DATA_FILE) $(BIB_FILE)
	@mkdir -p $(PROJECT_OUTPUT_DIR)
	@$(RUNNODE) $(GENERATOR) --outdir $(PROJECT_OUTPUT_DIR) \
	  --template $(PROJECT_TEMPLATE) \
	  --bib $(BIB_FILE) \
	  --csl $(ROOT_DIR)/bibliography/ieee.csl

deps:
	@if [ ! -d "node_modules" ]; then \
		echo "Installing Node.js dependencies..."; \
		npm install; \
	else \
		echo "Node.js dependencies already installed."; \
	fi

prepare:
	@mkdir -p $(PROJECT_OUTPUT_DIR)

clean:
	@rm -f $(DOCX_OUT) $(PDF_OUT)
	@rmdir -p $(PROJECT_OUTPUT_DIR) 2>/dev/null || true
	@echo "Project outputs removed"
