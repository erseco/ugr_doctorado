###############################################################################
#
# PhD - Doctoral Project
# University of Granada
#
# Makefile for generating documentation with LaTeX, RMarkdown, and Markdown
#
# Author: Ernesto Serrano <erseco@correo.ugr.es>
###############################################################################

# Variables
R_SCRIPT := Rscript
PDF_ENGINE := tectonic
CURL := curl
SPELLCHECK := aspell
MARP := marp
OUTPUT_DIR := output
ZOTERO_BIB_URL := https://api.zotero.org/groups/5784268/items/top?format=biblatex
BIB_FILE := bibliography/references.bib
CSL := bibliography/ieee.csl
THESIS_TEX := thesis/thesis.tex
THESIS_PDF := $(OUTPUT_DIR)/thesis.pdf

# Main rules
.PHONY: all thesis project papers slides clean lint validate update-bib check-dependencies help

# Default target
.DEFAULT_GOAL := help

# Build everything
all: check-dependencies update-bib thesis project papers slides

# Verify dependencies
check-dependencies: check-r check-tectonic check-curl check-spellcheck check-marp

check-r:
	@command -v Rscript >/dev/null 2>&1 || { \
		echo "Error: R is not installed. Please install it."; \
		exit 1; \
	}

check-tectonic:
	@command -v $(PDF_ENGINE) >/dev/null 2>&1 || { \
		echo "Error: $(PDF_ENGINE) is not installed. Please install it."; \
		exit 1; \
	}

check-curl:
	@command -v $(CURL) >/dev/null 2>&1 || { \
		echo "Error: curl is not installed. Please install it."; \
		exit 1; \
	}

check-spellcheck:
	@command -v $(SPELLCHECK) >/dev/null 2>&1 || { \
		echo "Error: $(SPELLCHECK) is not installed. Please install it."; \
		exit 1; \
	}

check-marp:
	@command -v $(MARP) >/dev/null 2>&1 || { \
		echo "Error: $(MARP) is not installed. Please install it."; \
		exit 1; \
	}

# Update bibliography from Zotero
update-bib:
	@echo "Downloading bibliography from Zotero..."
	@mkdir -p bibliography
	@$(CURL) -sSL "$(ZOTERO_BIB_URL)" -o $(BIB_FILE)
	@echo "Bibliography updated: $(BIB_FILE)"

# Build Thesis
thesis: $(THESIS_PDF)

# Find Rmd files in thesis
THESIS_RMD := $(wildcard thesis/*.Rmd)
THESIS_TEX := $(patsubst thesis/%.Rmd, thesis/%.tex, $(THESIS_RMD))

# Find Rmd files in thesis chapters
THESIS_CHAPTERS_RMD := $(wildcard thesis/chapters/*.Rmd)
THESIS_CHAPTERS_TEX := $(patsubst thesis/chapters/%.Rmd, thesis/chapters/%.tex, $(THESIS_CHAPTERS_RMD))

# Convert Rmd files to tex
thesis/%.tex: thesis/%.Rmd
	@echo "Rendering $< to $@..."
	@$(R_SCRIPT) -e "knitr::knit('$<', output = '$@')"

thesis/chapters/%.tex: thesis/chapters/%.Rmd
	@echo "Rendering $< to $@..."
	@$(R_SCRIPT) -e "knitr::knit('$<', output = '$@')"

# Build thesis PDF
$(THESIS_PDF): $(THESIS_TEX) $(THESIS_CHAPTERS_TEX) $(THESIS_TEX)
	@mkdir -p $(OUTPUT_DIR)
	@echo "Compiling thesis..."
	@$(PDF_ENGINE) -o $@ $(THESIS_TEX)
	@echo "Thesis compiled: $@"

# Build Project
project: $(OUTPUT_DIR)/project.pdf

$(OUTPUT_DIR)/project.pdf: project/project.Rmd bibliography/*.bib
	@mkdir -p $(OUTPUT_DIR)
	@$(R_SCRIPT) -e "rmarkdown::render('$<', output_file='$@', output_format = rmarkdown::pdf_document(latex_engine = '$(PDF_ENGINE)'), params = list(bibliography = '$(BIB_FILE)', csl = '$(CSL)'))"
	@echo "Project compiled: $@"

# Build Papers
papers: $(PAPERS_PDF)

PAPERS_SRC := $(wildcard papers/*/*.Rmd)
PAPERS_PDF := $(patsubst papers/%.Rmd, $(OUTPUT_DIR)/papers/%.pdf, $(PAPERS_SRC))

$(OUTPUT_DIR)/papers/%.pdf: papers/%/*.Rmd | $(OUTPUT_DIR)/papers/%
	@mkdir -p $(dir $@)
	@$(R_SCRIPT) -e "rmarkdown::render('$<', output_file='$@', output_format = rmarkdown::pdf_document(latex_engine = '$(PDF_ENGINE)'), params = list(bibliography = '$(BIB_FILE)', csl = '$(CSL)'))"
	@echo "Paper compiled: $@"

# Ensure output directories for papers
$(OUTPUT_DIR)/papers/%:
	@mkdir -p $@

# Build Slides
slides: $(SLIDES_PDF)

SLIDES_SRC := $(wildcard slides/*.md)
SLIDES_PDF := $(patsubst slides/%.md, $(OUTPUT_DIR)/slides/%.pdf, $(SLIDES_SRC))

$(OUTPUT_DIR)/slides/%.pdf: slides/%.md | $(OUTPUT_DIR)/slides
	@mkdir -p $(dir $@)
	@$(MARP) $< -o $@
	@echo "Slide compiled: $@"

# Ensure output directory for slides
$(OUTPUT_DIR)/slides:
	@mkdir -p $@

# Lint LaTeX code
lint:
	@echo "Checking LaTeX code style..."
	@find thesis/ -name "*.tex" -exec $(SPELLCHECK) --lang=en --mode=tex check {} \;

# Validate Thesis Compilation
validate: check-dependencies
	@echo "Validating LaTeX compilation with RMarkdown..."
	@$(R_SCRIPT) -e "rmarkdown::render('project/project.Rmd', output_format = rmarkdown::pdf_document(latex_engine = '$(PDF_ENGINE)'), output_file = '$(OUTPUT_DIR)/project_validate.pdf', params = list(bibliography = '$(BIB_FILE)', csl = '$(CSL)'))" || { \
		echo "Error: Project compilation failed. Check LaTeX errors."; \
		exit 1; \
	}
	@echo "Validation complete: The project compiles successfully."

# Install minimal dependencies on Mac using Homebrew
deps-mac:
	@brew install R
	@brew install tectonic
	@brew install aspell
	@brew install marp-cli
	@$(R_SCRIPT) -e "install.packages(c('rmarkdown', 'knitr'), repos='https://cloud.r-project.org')"

# Install minimal dependencies on Debian
deps-deb:
	@sudo apt-get update
	@sudo apt-get install -y r-base
	@sudo apt-get install -y aspell
	@sudo apt-get install -y npm
	@sudo npm install -g @marp-team/marp-cli
	@sudo apt-get install -y wget
	# Install Tectonic
	@wget https://github.com/tectonic-typesetting/tectonic/releases/download/latest/tectonic-install.sh -O /tmp/tectonic-install.sh
	@chmod +x /tmp/tectonic-install.sh
	@sudo /tmp/tectonic-install.sh
	@$(R_SCRIPT) -e "install.packages(c('rmarkdown', 'knitr'), repos='https://cloud.r-project.org')"

# Clean generated files
clean:
	@echo "Cleaning temporary and output files..."
	@rm -rf $(OUTPUT_DIR)
	@find thesis/ -name "*.aux" -o -name "*.lof" -o -name "*.log" -o -name "*.lol" \
		-o -name "*.lot" -o -name "*.out" -o -name "*.synctex.gz" -o -name "*.toc" \
		-o -name "*.run.xml" -o -name "*.bbl" -o -name "*.bcf" -o -name "*.blg" | xargs rm -f
	@find thesis/ -name "*.tex" -o -name "*.pdf" -o -name "*.md" | xargs rm -f

# Help menu
help:
	@echo "Available commands:"
	@echo "  all                - Build everything (thesis, project, papers, slides)"
	@echo "  thesis             - Build the thesis PDF"
	@echo "  project            - Build the project PDF"
	@echo "  papers             - Build PDFs for all papers"
	@echo "  slides             - Build PDFs for all slides"
	@echo "  lint               - Check LaTeX code style and spelling"
	@echo "  validate           - Validate that the project compiles correctly"
	@echo "  update-bib         - Download bibliography from Zotero in biblatex format"
	@echo "  deps-mac	        - Download and install deps for Mac"	
	@echo "  deps-deb	        - Download and install deps for Debian/Ubuntu"	
	@echo "  clean              - Remove temporary and generated files"
	@echo "  help               - Show this help menu"
	@echo ""
	@echo "Additional checks:"
	@echo "  check-r            - Verify that R is installed"
	@echo "  check-tectonic     - Verify that tectonic is installed"
	@echo "  check-curl         - Verify that curl is installed"
	@echo "  check-spellcheck   - Verify that $(SPELLCHECK) is installed"
	@echo "  check-marp         - Verify that $(MARP) is installed"
