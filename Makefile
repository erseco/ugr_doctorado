###############################################################################
#
# PhD - Doctoral Project
# University of Granada
#
# Makefile for generating documentation
#
# Author: Ernesto Serrano <erseco@correo.ugr.es>
###############################################################################

# Variables
SPELLCHECK := aspell
OUTPUT_DIR := output
ZOTERO_BIB_URL := https://api.zotero.org/groups/5784268/items/top?format=biblatex
BIB_FILE := bibliography/references.bib

# Main rules
.PHONY: all project papers slides thesis clean lint update-bib check-dependencies help

# Default target
.DEFAULT_GOAL := help

# Build everything 
all: check-dependencies update-bib project papers thesis slides

# Verify dependencies
check-dependencies: check-r check-tectonic check-spellcheck check-marp

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

# Update bibliography from Zotero
update-bib:
	@echo "Downloading bibliography from Zotero..."
	@mkdir -p bibliography
	curl -sSL "$(ZOTERO_BIB_URL)" -o $(BIB_FILE)
	@echo "Bibliography updated: $(BIB_FILE)"


# Create output dir (if not exists)
prepare:
	@mkdir -p $(OUTPUT_DIR)

# ----------------------------
# ----------------------------
# Build Thesis
thesis: prepare convert_chapters $(OUTPUT_DIR)/thesis.pdf clean_generated_tex

# Variables for .tex generation
THESIS_CHAPTERS_RNW := $(wildcard thesis/chapters/*.Rnw)
THESIS_CHAPTERS_RMD := $(wildcard thesis/chapters/*.Rmd)
THESIS_CHAPTERS_TEX := $(patsubst thesis/chapters/%.Rnw, thesis/chapters/%.tex, $(THESIS_CHAPTERS_RNW)) \
                       $(patsubst thesis/chapters/%.Rmd, thesis/chapters/%.tex, $(THESIS_CHAPTERS_RMD))

# Convert .Rnw to .tex
thesis/chapters/%.tex: thesis/chapters/%.Rnw
	@echo "Converting $< to $@..."
	@Rscript -e "setwd('$(dir $<)'); knitr::knit('$(notdir $<)')"
# 	@Rscript -e "setwd('$(dir $<)../'); knitr::knit('../$<')"
# 	@Rscript -e "setwd('thesis'); knitr::knit('../$<)')"

# @Rscript -e "setwd('$(dir $<)'); knitr::knit('$(notdir $<)')"
	

# Convert .Rmd to .tex (DISABLED because knitr can't generate .tex from .Rmd yet)
# thesis/chapters/%.tex: thesis/chapters/%.Rmd
# 	@echo "Converting $< to $@..."
# 	@Rscript -e "setwd('$(dir $<)'); knitr::opts_knit$$set(out.format = 'latex'); knitr::knit(input = '$(notdir $<)', output = '$(notdir $@)')"


# Convert all chapters
convert_chapters: $(THESIS_CHAPTERS_TEX)
	@echo "All chapters converted to .tex."
	@echo "Moving chapter figures directory to parent before generating full PDF."
	@test -d thesis/chapters/figure && mv thesis/chapters/figure thesis/ || true

# Generate thesis.pdf
$(OUTPUT_DIR)/thesis.pdf: thesis/thesis.tex $(THESIS_CHAPTERS_TEX)
	@mkdir -p $(OUTPUT_DIR)
	@echo "Compiling thesis with Tectonic..."
	@tectonic thesis/thesis.tex
	@mv thesis/thesis.pdf $(OUTPUT_DIR)/thesis.pdf
	@echo "Thesis compiled successfully and moved to $(OUTmaPUT_DIR)."

# Clean Knitr generated .tex
clean_generated_tex:
	@echo "Cleaning up temporary .tex files..."
	@rm -f $(THESIS_CHAPTERS_TEX)
	@echo "Temporary .tex files removed."
	@echo "Cleaning up temporary figure files..."
	@rm -rf thesis/figure


# ----------------------------
# ----------------------------
# Build Project

project: prepare
	@echo "Rendering project..."
	Rscript -e "rmarkdown::render('project/project.Rmd', \
		output_file='project.pdf', \
		output_format=rmarkdown::pdf_document(latex_engine=\"tectonic\"), \
		quiet = FALSE)" || { \
		echo 'Error: Failed to compile $<'; \
		exit 1; \
	}
	@mv project/project.pdf output/
	@echo "Project compiled"

# -----------------------------
# -----------------------------
# Build Papers (Rnw and/or Rmw)

papers: papersnw papersmd

# Create output dir (if not exists)
prepare-papers: prepare
	@mkdir -p $(OUTPUT_DIR)/papers

PAPERS_DIR := papers

# Find all .Rnw files inside the papers folder
RNW_FILES := $(shell find $(PAPERS_DIR) -type f -name '*.Rnw')
# Change the .Rnw extension to .pdf for the final outputs
PDFSNW := $(RNW_FILES:.Rnw=.pdf)

papersnw: prepare-papers $(PDFSNW)

# Generate .tex from .Rnw using knitr with setwd
%.tex: %.Rnw
	Rscript -e "setwd('$(dir $<)'); knitr::knit('$(notdir $<)')"

# Generate the PDF with tectonic and move it to the output directory
%.pdf: %.tex
	tectonic $<
	mv $@ $(OUTPUT_DIR)/papers/
	@echo "Cleaning up temporary figure files..."
	@rm -rf $(dir $<)figure



RMD_FILES := $(shell find $(PAPERS_DIR) -type f -name '*.Rmd')

# Change the .Rmd extension to .pdf for the final outputs
PDFSMD := $(RMD_FILES:.Rmd=.pdf)

papersmd: prepare-papers $(PDFSMD)

# Generate the PDF directly from .Rmd files using rmarkdown
%.pdf: %.Rmd
	Rscript -e "rmarkdown::render('$<', \
		output_file='$(notdir $(@F))', \
		output_format=rmarkdown::pdf_document(latex_engine='tectonic'), \
		quiet = FALSE)" || { \
		echo 'Error: Failed to compile $<'; \
		exit 1; \
	}
	mv $(basename $<).pdf $(OUTPUT_DIR)/papers/

$(dir $<)


# ----------------------------
# ----------------------------
# Build Slides
slides: $(SLIDES_PDF)

SLIDES_SRC := $(wildcard slides/*.md)
SLIDES_PDF := $(patsubst slides/%.md, $(OUTPUT_DIR)/slides/%.pdf, $(SLIDES_SRC))

$(OUTPUT_DIR)/slides/%.pdf: slides/%.md
	@mkdir -p $(dir $@)
	@marp $< -o $@
	@echo "Slide compiled: $@"

slides: $(SLIDES_PDF)
	@echo "All slides compiled successfully."
	@mkdir -p $@


# Lint LaTeX code
lint:
	@echo "Checking LaTeX code style..."
	@find thesis/ -name "*.tex" -exec $(SPELLCHECK) --lang=en --mode=tex check {} \;

# Install minimal dependencies on Mac using Homebrew
deps-mac:
	@brew install R
	@brew install tectonic
	@brew install aspell
	@brew install marp-cli
	@Rscript -e "install.packages(c('rmarkdown', 'knitr', 'ggplot2', 'ggthemes'), repos='https://cloud.r-project.org')"

# Install minimal dependencies on Debian
deps-deb:
	@sudo apt-get update
	@sudo apt-get install -y r-base
	@sudo apt-get install -y aspell aspell-es
	@sudo apt-get install -y npm
	@sudo npm install -g @marp-team/marp-cli
	@sudo apt-get install -y wget
	# Install Tectonic
	@wget https://github.com/tectonic-typesetting/tectonic/releases/download/latest/tectonic-install.sh -O /tmp/tectonic-install.sh
	@chmod +x /tmp/tectonic-install.sh
	@sudo /tmp/tectonic-install.sh
	@Rscript -e "install.packages(c('rmarkdown', 'knitr', 'ggplot2', 'ggthemes'), repos='https://cloud.r-project.org')"

# Clean generated files
clean:
	@echo "Cleaning temporary and output files..."
	@rm -rf $(OUTPUT_DIR)

# Help menu
help:
	@echo "Available commands:"
	@echo "  all                - Build everything (thesis, project, papers, slides)"
	@echo "  thesis             - Build the thesis PDF"
	@echo "  project            - Build the project PDF"
	@echo "  papers             - Build PDFs for all papers"
	@echo "  slides             - Build PDFs for all slides"
	@echo "  lint               - Check LaTeX code style and spelling"
	@echo "  update-bib         - Download bibliography from Zotero in biblatex format"
	@echo "  deps-mac	        - Download and install deps for Mac"	
	@echo "  deps-deb	        - Download and install deps for Debian/Ubuntu"	
	@echo "  clean              - Remove temporary and generated files"
	@echo "  help               - Show this help menu"
	@echo ""
	@echo "Additional checks:"
	@echo "  check-r            - Verify that R is installed"
	@echo "  check-tectonic     - Verify that tectonic is installed"
	@echo "  check-spellcheck   - Verify that $(SPELLCHECK) is installed"
	@echo "  check-marp         - Verify that marp is installed"
