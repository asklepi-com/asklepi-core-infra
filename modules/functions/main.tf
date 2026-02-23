locals {
  github_repositories = distinct(compact(concat([var.github_repository], tolist(var.additional_github_repositories))))
}

data "google_project" "current" {
  project_id = var.project_id
}

locals {
  default_compute_service_account_email = "${data.google_project.current.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_service" "required" {
  for_each = var.required_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "runtime" {
  project      = var.project_id
  account_id   = var.runtime_service_account_id
  display_name = var.runtime_service_account_display_name

  depends_on = [google_project_service.required]
}

resource "google_service_account" "ci_deployer" {
  project      = var.project_id
  account_id   = var.ci_deployer_service_account_id
  display_name = var.ci_deployer_service_account_display_name

  depends_on = [google_project_service.required]
}

resource "google_project_iam_member" "runtime_roles" {
  for_each = toset(var.runtime_project_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_project_iam_member" "ci_deployer_roles" {
  for_each = toset(var.ci_deployer_project_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.ci_deployer.email}"
}

resource "google_service_account_iam_member" "ci_can_act_as_runtime" {
  service_account_id = google_service_account.runtime.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.ci_deployer.email}"
}

resource "google_service_account_iam_member" "ci_can_act_as_default_compute" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${local.default_compute_service_account_email}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.ci_deployer.email}"

  depends_on = [
    google_project_service.required,
    google_service_account.ci_deployer,
  ]
}

resource "google_project_iam_member" "default_compute_builder" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${local.default_compute_service_account_email}"

  depends_on = [google_project_service.required]
}

resource "google_service_account_iam_member" "github_wif_user" {
  for_each = (length(var.workload_identity_pool_name) > 0 && length(local.github_repositories) > 0) ? toset(local.github_repositories) : toset([])

  service_account_id = google_service_account.ci_deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${var.workload_identity_pool_name}/attribute.repository/${each.value}"
}

resource "google_secret_manager_secret" "runtime" {
  project   = var.project_id
  secret_id = var.runtime_secret_name

  replication {
    auto {}
  }

  depends_on = [google_project_service.required]
}

resource "google_secret_manager_secret_iam_member" "runtime_secret_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.runtime.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_secret_manager_secret_iam_member" "ci_secret_version_adder" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.runtime.secret_id
  role      = "roles/secretmanager.secretVersionAdder"
  member    = "serviceAccount:${google_service_account.ci_deployer.email}"
}

resource "google_secret_manager_secret_iam_member" "ci_secret_viewer" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.runtime.secret_id
  role      = "roles/secretmanager.viewer"
  member    = "serviceAccount:${google_service_account.ci_deployer.email}"
}

resource "google_cloudfunctions2_function" "function" {
  count = var.deploy_enabled ? 1 : 0

  project  = var.project_id
  name     = var.function_name
  location = var.region

  build_config {
    runtime     = var.function_runtime
    entry_point = var.function_entry_point

    source {
      storage_source {
        bucket = var.function_source_bucket
        object = var.function_source_object
      }
    }
  }

  service_config {
    timeout_seconds       = var.function_timeout_seconds
    available_memory      = var.function_available_memory
    min_instance_count    = var.function_min_instance_count
    max_instance_count    = var.function_max_instance_count
    ingress_settings      = var.function_ingress_settings
    service_account_email = google_service_account.runtime.email
    environment_variables = var.function_environment_variables
  }

  depends_on = [
    google_project_service.required,
    google_service_account.runtime,
    google_service_account.ci_deployer,
  ]

  lifecycle {
    precondition {
      condition     = length(var.function_source_bucket) > 0 && length(var.function_source_object) > 0
      error_message = "function_source_bucket and function_source_object must be set when deploy_enabled=true."
    }
  }
}

resource "google_cloudfunctions2_function_iam_member" "invoker" {
  for_each = var.deploy_enabled ? toset(var.invoker_members) : toset([])

  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.function[0].name
  role           = "roles/cloudfunctions.invoker"
  member         = each.value
}
