###############################################################################
#
# PhD - Doctoral Project
# Universidad de Granada
#
# Makefile for generating documentation with LaTeX and Markdown
#
# Author: Ernesto Serrano <erseco@correo.ugr.es>
###############################################################################

# Variables
PANDOC = pandoc
LATEX = pdflatex
BIBER = biber
CURL = curl
SPELLCHECK = aspell
OUTPUT_DIR = output
ZOTERO_BIB_URL = https://api.zotero.org/groups/5784268/items/top?format=biblatex
BIB_FILE = bibliography/references.bib

# Files
THESIS_SRC = thesis/project.tex
THESIS_PDF = $(OUTPUT_DIR)/thesis.pdf

SLIDES_SRC = $(wildcard slides/*.md)
SLIDES_PDF = $(patsubst %.md, $(OUTPUT_DIR)/%.pdf, $(SLIDES_SRC))

PAPERS_SRC = $(wildcard papers/*/*.md)
PAPERS_PDF = $(patsubst %.md, $(OUTPUT_DIR)/%.pdf, $(PAPERS_SRC))

# Main rules
.PHONY: all thesis papers slides clean lint validate check-latex check-pandoc help

# Default target
.DEFAULT_GOAL := help

# Build everything
all: check-latex check-pandoc thesis papers slides

# Verify dependencies
check-latex:
	@command -v $(LATEX) >/dev/null 2>&1 || { \
		echo "Error: pdflatex is not installed. Please install LaTeX (e.g., TeX Live or MacTeX)."; \
		exit 1; \
	}

check-pandoc:
	@command -v $(PANDOC) >/dev/null 2>&1 || { \
		echo "Error: pandoc is not installed. Please install it."; \
		exit 1; \
	}

# Update bibliography from Zotero
update-bib:
	@echo "Downloading bibliography from Zotero..."
	@mkdir -p bibliography
	@$(CURL) -sSL "$(ZOTERO_BIB_URL)" -o $(BIB_FILE)
	@echo "Bibliography updated: $(BIB_FILE)"

# Build thesis
thesis: $(THESIS_PDF)

$(THESIS_PDF): $(THESIS_SRC)
	@mkdir -p $(OUTPUT_DIR)
	$(LATEX) -shell-escape -synctex=1 -interaction=nonstopmode -output-directory=$(OUTPUT_DIR) $<
	$(BIBER) $(basename $(OUTPUT_DIR)/$(notdir $<))
	$(LATEX) -shell-escape -synctex=1 -interaction=nonstopmode -output-directory=$(OUTPUT_DIR) $<
	$(LATEX) -shell-escape -synctex=1 -interaction=nonstopmode -output-directory=$(OUTPUT_DIR) $<

# Build papers
papers: $(PAPERS_PDF)

$(OUTPUT_DIR)/%.pdf: %.md
	@mkdir -p $(dir $@)
	$(PANDOC) $< -o $@

# Build slides
slides: $(SLIDES_PDF)

$(OUTPUT_DIR)/%.pdf: %.md
	@mkdir -p $(dir $@)
	$(PANDOC) $< -o $@

# Lint LaTeX code
lint:
	@echo "Checking LaTeX code style..."
	@$(SPELLCHECK) --lang=en --mode=tex check $(THESIS_SRC)
	@find thesis/ -name "*.tex" -exec $(SPELLCHECK) --lang=en --mode=tex check "{}" \;

# Validate thesis compilation
validate:
	@echo "Validating LaTeX compilation..."
	@$(LATEX) -shell-escape -synctex=1 -interaction=nonstopmode -output-directory=$(OUTPUT_DIR) $(THESIS_SRC) || { \
		echo "Error: Failed to compile thesis. Check LaTeX errors."; \
		exit 1; \
	}
	@echo "Validation complete: Thesis compiles successfully."

# Clean generated files
clean:
	@echo "Cleaning temporary and output files..."
	@rm -rf $(OUTPUT_DIR)/* thesis/*.aux thesis/*.lof thesis/*.log thesis/*.lol \
		thesis/*.lot thesis/*.out thesis/*.synctex.gz thesis/*.toc thesis/*.run.xml \
		thesis/*.bbl thesis/*.bcf thesis/*.blg

# Help menu
help:
	@echo "Available commands:"
	@echo "  all                - Build everything (thesis, papers, slides)"
	@echo "  thesis             - Build the thesis PDF"
	@echo "  papers             - Build all paper PDFs"
	@echo "  slides             - Build all slide PDFs"
	@echo "  lint               - Check LaTeX style and spelling"
	@echo "  validate           - Validate that the thesis compiles successfully"
	@echo "  update-bib         - Download bibliography from Zotero in biblatex format"	
	@echo "  clean              - Remove temporary and generated files"
	@echo "  help               - Show this help menu"
	@echo ""
	@echo "Additional checks:"
	@echo "  check-latex        - Verify that pdflatex is installed"
	@echo "  check-pandoc       - Verify that pandoc is installed"
