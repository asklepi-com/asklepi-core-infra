include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/asklepi-com/asklepi-github-bootstrapper.git//modules/github-repository?ref=v1.1.1"
}

inputs = {
  repo_name = "asklepi-core-infra"

  github_environments = ["dev"]

  github_actions_variables = {
    GCP_WORKLOAD_IDENTITY_PROVIDER = "projects/920942711813/locations/global/workloadIdentityPools/github-pool/providers/github-provider"
    GCP_TERRAFORM_SA               = "tf-core-dev-apply@asklepi-core-dev.iam.gserviceaccount.com"
  }

  write_repository_actions_variables = false
}
