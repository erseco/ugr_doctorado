ROOT_DIR ?= $(abspath ..)
OUTPUT_DIR ?= $(ROOT_DIR)/output
PROJECT_OUTPUT_DIR := $(OUTPUT_DIR)/project
BIB_FILE ?= $(ROOT_DIR)/bibliography/references.bib
RUNNODE ?= node
GENERATOR := generate.js
PROJECT_TEMPLATE := project_template.docx
DATA_FILE := data.yaml
DOCX_OUT := $(PROJECT_OUTPUT_DIR)/project.docx
PDF_OUT := $(PROJECT_OUTPUT_DIR)/project.pdf

.PHONY: pdf clean prepare
.DEFAULT_GOAL := pdf

pdf: prepare $(PDF_OUT)
	@echo "Project files generated in $(PROJECT_OUTPUT_DIR)"

$(PDF_OUT): $(GENERATOR) $(PROJECT_TEMPLATE) $(DATA_FILE) $(BIB_FILE)
	@mkdir -p $(PROJECT_OUTPUT_DIR)
	@$(RUNNODE) $(GENERATOR) --outdir $(PROJECT_OUTPUT_DIR) \
	  --template $(PROJECT_TEMPLATE) \
	  --bib $(BIB_FILE) \
	  --csl $(ROOT_DIR)/bibliography/ieee.csl

prepare:
	@mkdir -p $(PROJECT_OUTPUT_DIR)

clean:
	@rm -f $(DOCX_OUT) $(PDF_OUT)
	@rmdir -p $(PROJECT_OUTPUT_DIR) 2>/dev/null || true
	@echo "Project outputs removed"
