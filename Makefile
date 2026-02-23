SHELL := /bin/bash

.PHONY: fmt validate-hcl plan-dev plan-stage plan-prod apply-dev apply-stage apply-prod

TG_RUN_FLAGS := --non-interactive --backend-bootstrap=false

fmt:
	terraform fmt -recursive .
	terragrunt hcl format
clean:
	terragrunt run --all clean $(TG_RUN_FLAGS)

validate-hcl:
	cd bootstrap/gcp && terragrunt hcl validate --all --inputs
	cd envs/dev && terragrunt hcl validate
	cd envs/stage && terragrunt hcl validate
	cd envs/prod && terragrunt hcl validate

plan-dev:
	cd bootstrap/gcp/dev && terragrunt plan $(TG_RUN_FLAGS)
	cd envs/dev && terragrunt run --all plan $(TG_RUN_FLAGS)

plan-stage:
	cd bootstrap/gcp/stage && terragrunt plan $(TG_RUN_FLAGS)
	cd envs/stage && terragrunt run --all plan $(TG_RUN_FLAGS)

plan-prod:
	cd bootstrap/gcp/prod && terragrunt plan $(TG_RUN_FLAGS)
	cd envs/prod && terragrunt run --all plan $(TG_RUN_FLAGS)

apply-dev:
	cd envs/dev && terragrunt run --all apply $(TG_RUN_FLAGS)

apply-stage:
	cd bootstrap/gcp/stage && terragrunt apply $(TG_RUN_FLAGS)
	cd envs/stage && terragrunt run --all apply $(TG_RUN_FLAGS)

apply-prod:
	cd bootstrap/gcp/prod && terragrunt apply $(TG_RUN_FLAGS)
	cd envs/prod && terragrunt run --all apply $(TG_RUN_FLAGS)
