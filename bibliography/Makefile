ROOT_DIR ?= $(abspath ..)
BIB_DIR := $(ROOT_DIR)/bibliography
BIB_FILE ?= $(BIB_DIR)/references.bib
ZOTERO_BIB_URL ?= https://api.zotero.org/groups/5784268/items/top?format=biblatex
CURL ?= curl

.PHONY: update clean

update:
	@echo "Downloading bibliography from Zotero..."
	@mkdir -p $(dir $(BIB_FILE))
	@$(CURL) -sSL "$(ZOTERO_BIB_URL)" -o $(BIB_FILE)
	@echo "Bibliography updated: $(BIB_FILE)"

clean:
	@rm -f $(BIB_FILE)
	@echo "Removed bibliography file"
