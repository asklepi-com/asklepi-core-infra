.DEFAULT_GOAL := help
REPO_NAME := asklepi-core-infra

.PHONY: help fmt validate tg-init tg-plan apply

##@ General

.PHONY: help
help: ## Show help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Dependencies

TERRAGRUNT_CMD ?= terragrunt
TERRAFORM_CMD ?= terraform
TFLINT ?= tflint
TRIVY ?= trivy


##@ Development

fmt: ## Format Terraform and Terragrunt files
	terragrunt hcl format
	terraform fmt -recursive

.PHONY: tg-import-repo-settings
tg-import-repo-settings: ## Import existing repository settings resource (set REPO_NAME)
	@if [ -z "$(REPO_NAME)" ]; then \
		echo "Usage: make tg-import-repo-settings REPO_NAME=$(REPO_NAME)"; \
		exit 1; \
	fi
	cd repo && $(TERRAGRUNT_CMD) import "github_repository.settings[0]" "$(REPO_NAME)"


validate: ## Validate Terragrunt files
	terragrunt hcl validate --all --inputs

tg-init: ## Initialize Terragrunt
	terragrunt run --all init --non-interactive

tg-plan: ## Plan GitHub bootstrap resources
	terragrunt run --all plan --non-interactive

apply: ## Apply GitHub bootstrap resources
	terragrunt run --all apply --non-interactive --no-auto-approve
