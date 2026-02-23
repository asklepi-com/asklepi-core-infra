SHELL := /bin/bash

.PHONY: fmt validate-hcl plan-dev plan-stage plan-prod apply-dev apply-stage apply-prod

fmt:
	terraform fmt -recursive .
	terragrunt hcl format

validate-hcl:
	cd envs/dev && terragrunt hcl validate
	cd envs/stage && terragrunt hcl validate
	cd envs/prod && terragrunt hcl validate

plan-dev:
	cd envs/dev && terragrunt run --all plan --non-interactive

plan-stage:
	cd envs/stage && terragrunt run --all plan --non-interactive

plan-prod:
	cd envs/prod && terragrunt run --all plan --non-interactive

apply-dev:
	cd envs/dev && terragrunt run --all apply --non-interactive

apply-stage:
	cd envs/stage && terragrunt run --all apply --non-interactive

apply-prod:
	cd envs/prod && terragrunt run --all apply --non-interactive
