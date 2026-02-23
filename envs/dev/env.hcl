locals {
  environment = "dev"

  service_account_project_id            = "asklepi-core-dev"
  terraform_apply_service_account_id    = "tf-core-dev-apply"
  terraform_apply_service_account_display_name = "Core Infra Terraform Apply (dev)"

  target_project_roles = {
    "asklepi-core-dev" = [
      "roles/run.admin",
      "roles/cloudfunctions.admin",
      "roles/datastore.owner",
      "roles/secretmanager.admin",
      "roles/artifactregistry.admin",
      "roles/cloudbuild.builds.editor",
      "roles/serviceusage.serviceUsageAdmin",
      "roles/iam.serviceAccountAdmin"
    ]
  }
}
