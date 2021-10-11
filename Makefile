.ONESHELL:
.SHELL := /bin/bash
.PHONY: ALL
.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

pre-commit-install: ## Install pre-commit into your git hooks. After that pre-commit will now run on every commit.
	pre-commit install

pre-commit-all: ## Manually run all pre-commit hooks on a repository (all files).
	pre-commit run --all-files

readme-generator: ## Autogenerate Helm Charts READMEs' tables based on values YAML file metadata.
ifndef CHART_FOLDER
	$(error CHART_FOLDER is undefined)
endif
	readme-generator -r charts/$(CHART_FOLDER)/README.md -v charts/$(CHART_FOLDER)/values.yaml -m charts/$(CHART_FOLDER)/values.schema.json

# New targets here
