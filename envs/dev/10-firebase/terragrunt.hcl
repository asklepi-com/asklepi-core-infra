include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependencies {
  paths = ["../00-apply-identity"]
}

terraform {
  source = "../../../modules/firebase"
}

inputs = {
  project_id    = local.env.locals.project_id
  database_id   = local.env.locals.firebase.database_id
  database_type = local.env.locals.firebase.database_type
  location_id   = local.env.locals.firebase.location_id
}
