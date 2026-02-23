locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Terragrunt backend bootstrap requires an explicit GCS project.
  remote_state_project = coalesce(
    try(local.common.locals.state_project_id, ""),
    try(local.env.locals.service_account_project_id, ""),
    local.env.locals.project_id
  )
}

remote_state {
  backend = "gcs"
  config = {
    bucket   = local.common.locals.state_bucket
    prefix   = "${local.common.locals.state_prefix}/${path_relative_to_include()}"
    location = local.common.locals.state_location
    project  = local.remote_state_project
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<PROVIDER
provider "google" {
  region = "${local.common.locals.default_region}"
}
PROVIDER
}
