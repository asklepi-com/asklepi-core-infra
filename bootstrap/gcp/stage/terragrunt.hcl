include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  env    = read_terragrunt_config("${get_terragrunt_dir()}/../../../envs/stage/env.hcl")
}

terraform {
  source = "../../../modules/terraform-apply-identity"
}

inputs = {
  service_account_project_id   = local.env.locals.service_account_project_id
  service_account_id           = local.env.locals.terraform_apply_service_account_id
  service_account_display_name = local.env.locals.terraform_apply_service_account_display_name

  github_repository               = "${local.common.locals.github_owner}/${local.common.locals.github_repo}"
  workload_identity_pool_name     = local.common.locals.workload_identity_pool_name
  workload_identity_provider_name = local.common.locals.workload_identity_provider_name

  target_project_roles = local.env.locals.target_project_roles
}
