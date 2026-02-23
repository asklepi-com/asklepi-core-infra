locals {
  state_bucket                    = "asklepi-tfstate-projects"
  state_project_id                = "asklepi-org-admin"
  state_prefix                    = "asklepi-core-infra"
  state_location                  = "europe-west1"
  default_region                  = "europe-west1"
  github_owner                    = "asklepi-com"
  github_repo                     = "asklepi-core-infra"
  workload_identity_provider_name = "projects/920942711813/locations/global/workloadIdentityPools/github-pool/providers/github-provider"
  workload_identity_pool_name     = "projects/920942711813/locations/global/workloadIdentityPools/github-pool"

  default_labels = {
    managed_by = "terraform"
    repository = "asklepi-core-infra"
    owner      = "platform"
  }
}
