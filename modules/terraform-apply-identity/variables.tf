variable "service_account_project_id" {
  description = "Project id where the Terraform apply service account is created."
  type        = string
}

variable "service_account_id" {
  description = "Service account id for Terraform apply identity."
  type        = string
}

variable "service_account_display_name" {
  description = "Display name for Terraform apply service account."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository in owner/repo format allowed to impersonate the service account."
  type        = string
}

variable "workload_identity_pool_name" {
  description = "Workload identity pool full resource name (projects/<number>/locations/global/workloadIdentityPools/<pool>)."
  type        = string
}

variable "workload_identity_provider_name" {
  description = "Workload identity provider full resource name used by GitHub Actions auth."
  type        = string
}

variable "target_project_roles" {
  description = "Map of project_id => list of roles granted to the Terraform apply service account."
  type        = map(list(string))
}
