# asklepi-core-infra

Infrastructure repository for Core backend runtime resources.

## Project scope

- `asklepi-core-dev`
- `asklepi-core-stage`
- `asklepi-core-prod`

Typical resources:
- Cloud Run services/jobs for core APIs
- Cloud Functions for business rules
- Firestore and supporting service IAM/networking
- Secret Manager bindings for core workloads

## Environments

- `dev`
- `stage`
- `prod`

## First stack

- `envs/<environment>/00-apply-identity`
- Creates Terraform apply service account (`tf-core-<env>-apply`)
- Grants project roles required for Core infra delivery
- Grants `roles/iam.workloadIdentityUser` for GitHub OIDC principal set

## GitHub environment variables

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
