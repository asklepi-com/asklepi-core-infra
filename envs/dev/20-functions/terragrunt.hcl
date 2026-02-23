include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependencies {
  paths = ["../00-apply-identity", "../10-firebase"]
}

terraform {
  source = "../../../modules/functions"
}

inputs = {
  project_id                     = local.env.locals.project_id
  region                         = local.common.locals.default_region
  function_name                  = local.env.locals.functions.function_name
  runtime_service_account_id     = local.env.locals.functions.runtime_service_account_id
  ci_deployer_service_account_id = local.env.locals.functions.ci_deployer_service_account_id
  runtime_secret_name            = local.env.locals.functions.runtime_secret_name
  runtime_project_roles          = local.env.locals.functions.runtime_project_roles
  ci_deployer_project_roles      = local.env.locals.functions.ci_deployer_project_roles

  workload_identity_pool_name     = local.common.locals.workload_identity_pool_name
  workload_identity_provider_name = local.common.locals.workload_identity_provider_name
  github_repository               = local.env.locals.functions.github_repository

  deploy_enabled                 = local.env.locals.functions.deploy_enabled
  function_runtime               = local.env.locals.functions.function_runtime
  function_entry_point           = local.env.locals.functions.function_entry_point
  function_source_bucket         = local.env.locals.functions.function_source_bucket
  function_source_object         = local.env.locals.functions.function_source_object
  function_timeout_seconds       = local.env.locals.functions.function_timeout_seconds
  function_available_memory      = local.env.locals.functions.function_available_memory
  function_min_instance_count    = local.env.locals.functions.function_min_instance_count
  function_max_instance_count    = local.env.locals.functions.function_max_instance_count
  function_ingress_settings      = local.env.locals.functions.function_ingress_settings
  function_environment_variables = local.env.locals.functions.function_environment_variables
  invoker_members                = local.env.locals.functions.invoker_members
}
