locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

remote_state {
  backend = "gcs"
  config = {
    bucket   = local.common.locals.state_bucket
    prefix   = "${local.common.locals.state_prefix}/${path_relative_to_include()}"
    location = local.common.locals.state_location
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
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  region = "${local.common.locals.default_region}"
}
PROVIDER
}
