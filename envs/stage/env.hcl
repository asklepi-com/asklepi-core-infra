locals {
  environment = "stage"

  service_account_project_id            = "asklepi-core-stage"
  terraform_apply_service_account_id    = "tf-core-stage-apply"
  terraform_apply_service_account_display_name = "Core Infra Terraform Apply (stage)"

  target_project_roles = {
    "asklepi-core-stage" = [
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
