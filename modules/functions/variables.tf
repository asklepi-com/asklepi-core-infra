variable "project_id" {
  description = "GCP project id for function platform resources."
  type        = string
}

variable "region" {
  description = "Cloud Functions Gen2 region."
  type        = string
  default     = "europe-west1"
}

variable "function_name" {
  description = "Cloud Function name."
  type        = string
  default     = "core-handler"
}

variable "runtime_service_account_id" {
  description = "Service account id used by runtime Cloud Function."
  type        = string
}

variable "runtime_service_account_display_name" {
  description = "Display name for runtime service account."
  type        = string
  default     = "Core Function Runtime"
}

variable "ci_deployer_service_account_id" {
  description = "Service account id used by CI for function deployments."
  type        = string
}

variable "ci_deployer_service_account_display_name" {
  description = "Display name for CI deployer service account."
  type        = string
  default     = "Core Function CI Deployer"
}

variable "runtime_secret_name" {
  description = "Secret Manager secret name read by runtime and written by CI."
  type        = string
  default     = "CORE_FUNCTION_RUNTIME_SECRET"
}

variable "runtime_project_roles" {
  description = "Project-level roles granted to runtime service account."
  type        = list(string)
  default     = ["roles/datastore.user"]
}

variable "ci_deployer_project_roles" {
  description = "Project-level roles granted to CI deployer service account."
  type        = list(string)
  default = [
    "roles/cloudfunctions.developer",
    "roles/run.developer",
    "roles/cloudbuild.builds.editor",
    "roles/artifactregistry.writer"
  ]
}

variable "workload_identity_pool_name" {
  description = "Workload identity pool full resource name used for GitHub repo trust."
  type        = string
  default     = ""
}

variable "workload_identity_provider_name" {
  description = "Workload identity provider full resource name for workflow output wiring."
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "Primary GitHub repository (owner/repo) allowed to impersonate deployer SA."
  type        = string
  default     = ""
}

variable "additional_github_repositories" {
  description = "Additional GitHub repositories (owner/repo) allowed to impersonate deployer SA."
  type        = set(string)
  default     = []
}

variable "deploy_enabled" {
  description = "Whether to manage and deploy Cloud Functions Gen2 resource."
  type        = bool
  default     = false
}

variable "function_runtime" {
  description = "Functions runtime, e.g. nodejs22, python312, go122."
  type        = string
  default     = "nodejs22"
}

variable "function_entry_point" {
  description = "Handler entry point symbol."
  type        = string
  default     = "handler"
}

variable "function_source_bucket" {
  description = "GCS bucket containing the uploaded function source archive."
  type        = string
  default     = ""
}

variable "function_source_object" {
  description = "GCS object path for the function source archive (zip)."
  type        = string
  default     = ""
}

variable "function_timeout_seconds" {
  description = "Function timeout in seconds."
  type        = number
  default     = 60
}

variable "function_available_memory" {
  description = "Function memory tier, e.g. 256M, 512M, 1G."
  type        = string
  default     = "512M"
}

variable "function_min_instance_count" {
  description = "Minimum instances kept warm."
  type        = number
  default     = 0
}

variable "function_max_instance_count" {
  description = "Maximum instances allowed."
  type        = number
  default     = 10
}

variable "function_ingress_settings" {
  description = "Ingress policy: ALLOW_ALL, ALLOW_INTERNAL_ONLY, or ALLOW_INTERNAL_AND_GCLB."
  type        = string
  default     = "ALLOW_INTERNAL_AND_GCLB"
}

variable "function_environment_variables" {
  description = "Runtime environment variables for the function."
  type        = map(string)
  default     = {}
}

variable "invoker_members" {
  description = "IAM members granted roles/cloudfunctions.invoker."
  type        = list(string)
  default     = []
}

variable "required_services" {
  description = "APIs to enable for Cloud Functions platform bootstrap."
  type        = set(string)
  default = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "firestore.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "sts.googleapis.com"
  ]
}
