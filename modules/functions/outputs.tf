output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "function_name" {
  value = var.function_name
}

output "runtime_service_account_email" {
  value = google_service_account.runtime.email
}

output "runtime_service_account_name" {
  value = google_service_account.runtime.name
}

output "ci_deployer_service_account_email" {
  value = google_service_account.ci_deployer.email
}

output "ci_deployer_service_account_name" {
  value = google_service_account.ci_deployer.name
}

output "runtime_secret_name" {
  value = google_secret_manager_secret.runtime.secret_id
}

output "workload_identity_provider_name" {
  value = var.workload_identity_provider_name
}

output "github_repositories" {
  value = local.github_repositories
}

output "deployed_function_name" {
  value = try(google_cloudfunctions2_function.function[0].name, null)
}

output "deployed_function_uri" {
  value = try(google_cloudfunctions2_function.function[0].service_config[0].uri, null)
}
