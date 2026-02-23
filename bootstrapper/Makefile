.DEFAULT_GOAL := help

.PHONY: help fmt validate tg-init tg-plan apply

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

fmt: ## Format Terraform and Terragrunt files
	terragrunt hcl format
	terraform fmt -recursive

validate: ## Validate Terragrunt files
	terragrunt hcl validate --all --inputs

tg-init: ## Initialize Terragrunt
	terragrunt run --all init --non-interactive

tg-plan: ## Plan bootstrapper resources
	terragrunt run --all plan --non-interactive

apply: ## Apply bootstrapper resources
	terragrunt run --all apply --non-interactive --no-auto-approve
