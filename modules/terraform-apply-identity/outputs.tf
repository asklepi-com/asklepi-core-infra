output "terraform_apply_service_account_email" {
  value = google_service_account.terraform_apply.email
}

output "terraform_apply_service_account_name" {
  value = google_service_account.terraform_apply.name
}

output "workload_identity_provider_name" {
  value = var.workload_identity_provider_name
}
