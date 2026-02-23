locals {
  environment = "prod"

  service_account_project_id            = "asklepi-core-prod"
  terraform_apply_service_account_id    = "tf-core-prod-apply"
  terraform_apply_service_account_display_name = "Core Infra Terraform Apply (prod)"

  target_project_roles = {
    "asklepi-core-prod" = [
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
