# asklepi-core-infra

Infrastructure repository for Core backend runtime resources.

## Project scope

- `asklepi-core-dev`
- `asklepi-core-stage`
- `asklepi-core-prod`

Typical resources:
- Firebase/Firestore configuration
- Cloud Functions Gen2 platform and deployment identities
- Cloud Run services/jobs for core APIs (next stacks)

## Environments

- `dev`
- `stage`
- `prod`

## Stack order

For each environment (`envs/dev`, `envs/stage`, `envs/prod`):
1. `00-apply-identity`
2. `10-firebase`
3. `20-functions`

## Modules configured

- `modules/firebase`
  - enables Firebase/Firestore APIs
  - creates Firestore database (`(default)` in `eur3`)
- `modules/functions`
  - enables Cloud Functions platform APIs
  - creates runtime + CI deployer service accounts
  - grants Secret Manager and project IAM for runtime/deployer
  - grants Workload Identity User on deployer SA to `asklepi-functions` repo
  - optionally deploys a Cloud Functions Gen2 HTTP function when `deploy_enabled=true`

## asklepi-functions integration

`asklepi-functions` owns function source code and deployment workflow.

Infra in this repo provides required identity/runtime values:
- `ci_deployer_service_account_email` -> set as `GCP_SERVICE_ACCOUNT_EMAIL`
- `runtime_service_account_email` -> set as `GCP_RUNTIME_SERVICE_ACCOUNT`
- `workload_identity_provider_name` -> set as `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `project_id` -> set as `GCP_PROJECT_ID`
- `runtime_secret_name` -> set as `TURNSTILE_SECRET_NAME`

In each `envs/<env>/env.hcl` under `locals.functions`:
- `github_repository` is set to `asklepi-com/asklepi-functions`
- this drives WIF trust binding for CI deployer SA impersonation

## Cloud Functions deployment behavior

`deploy_enabled` defaults to `false` in this repo so function code deployment remains owned by `asklepi-functions`.

If you want Terraform-managed function deployment later:
- set `deploy_enabled = true`
- set `function_source_bucket` and `function_source_object`
- ensure source zip exists in GCS

## GitHub environment variables (for asklepi-core-infra repo)

Managed via bootstrapper Terragrunt stacks:
- `bootstrapper/env-dev-vars`
- `bootstrapper/env-stage-vars`
- `bootstrapper/env-prod-vars`

Values:
- `dev`
  - `GCP_WORKLOAD_IDENTITY_PROVIDER=projects/920942711813/locations/global/workloadIdentityPools/github-pool/providers/github-provider`
  - `GCP_TERRAFORM_SA=tf-core-dev-apply@asklepi-core-dev.iam.gserviceaccount.com`
- `stage`
  - `GCP_WORKLOAD_IDENTITY_PROVIDER=projects/920942711813/locations/global/workloadIdentityPools/github-pool/providers/github-provider`
  - `GCP_TERRAFORM_SA=tf-core-stage-apply@asklepi-core-stage.iam.gserviceaccount.com`
- `prod`
  - `GCP_WORKLOAD_IDENTITY_PROVIDER=projects/920942711813/locations/global/workloadIdentityPools/github-pool/providers/github-provider`
  - `GCP_TERRAFORM_SA=tf-core-prod-apply@asklepi-core-prod.iam.gserviceaccount.com`

## Workflows

- `.github/workflows/plan.yml`: PR formatting and Terragrunt HCL validation
- `.github/workflows/apply.yml`: manual apply entrypoint (OIDC + WIF)

## Make targets

- `make fmt`
- `make validate-hcl`
- `make plan-dev|plan-stage|plan-prod`
- `make apply-dev|apply-stage|apply-prod`
