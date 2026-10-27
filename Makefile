# Oh-My-CodeReview — common format / check targets (macOS + Linux)
#
# Tools (install as needed):
#   prettier — JSON / YAML / Markdown (npm install -g prettier)
#
# Usage:
#   make help
#   make check

.PHONY: help format format-json format-yaml format-md check json-check yaml-check md-check install-format-tools

PRETTIER ?= prettier

# JSON / YAML / Markdown under the repo (exclude caches / venvs)
FIND_PRUNE := \( -path './.git/*' -o -path './.venv/*' -o -path './venv/*' \
	-o -path '*/node_modules/*' -o -path './.ruff_cache/*' -o -path './.soothe/*' \
	-o -path './.ocr/*' \) -prune

JSON_FILES = $(shell find . $(FIND_PRUNE) -o -type f -name '*.json' -print | sort)
YAML_FILES = $(shell find . $(FIND_PRUNE) -o -type f \( -name '*.yml' -o -name '*.yaml' \) -print | sort)
MD_FILES   = $(shell find . $(FIND_PRUNE) -o -type f -name '*.md' -print | sort)

help: ## Show available targets
	@echo "Oh-My-CodeReview format targets"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Tools: $(PRETTIER)"

format: format-json format-yaml ## Format JSON and YAML

format-json: ## Pretty-print JSON with prettier
	@files="$(JSON_FILES)"; \
	if [ -z "$$files" ]; then echo "No JSON files."; exit 0; fi; \
	command -v $(PRETTIER) >/dev/null 2>&1 || { echo "prettier not found. Try: make install-format-tools"; exit 1; }; \
	$(PRETTIER) --write --parser json $$files

format-yaml: ## Format YAML with prettier
	@files="$(YAML_FILES)"; \
	if [ -z "$$files" ]; then echo "No YAML files."; exit 0; fi; \
	command -v $(PRETTIER) >/dev/null 2>&1 || { echo "prettier not found. Try: make install-format-tools"; exit 1; }; \
	$(PRETTIER) --write $$files

format-md: ## Format Markdown with prettier (optional)
	@files="$(MD_FILES)"; \
	if [ -z "$$files" ]; then echo "No Markdown files."; exit 0; fi; \
	command -v $(PRETTIER) >/dev/null 2>&1 || { echo "prettier not found"; exit 1; }; \
	$(PRETTIER) --write --prose-wrap preserve $$files

check: json-check yaml-check md-check ## CI: verify format (no write)

json-check: ## Check JSON is pretty-printed
	@files="$(JSON_FILES)"; \
	if [ -z "$$files" ]; then echo "No JSON files."; exit 0; fi; \
	command -v $(PRETTIER) >/dev/null 2>&1 || { echo "prettier not found. Try: make install-format-tools"; exit 1; }; \
	$(PRETTIER) --check --parser json $$files

yaml-check: ## Check YAML formatting
	@files="$(YAML_FILES)"; \
	if [ -z "$$files" ]; then echo "No YAML files."; exit 0; fi; \
	command -v $(PRETTIER) >/dev/null 2>&1 || { echo "prettier not found. Try: make install-format-tools"; exit 1; }; \
	$(PRETTIER) --check $$files

md-check: ## Check Markdown formatting
	@files="$(MD_FILES)"; \
	if [ -z "$$files" ]; then echo "No Markdown files."; exit 0; fi; \
	command -v $(PRETTIER) >/dev/null 2>&1 || { echo "prettier not found. Try: make install-format-tools"; exit 1; }; \
	$(PRETTIER) --check --prose-wrap preserve $$files

install-format-tools: ## Install prettier globally
	npm install -g prettier
