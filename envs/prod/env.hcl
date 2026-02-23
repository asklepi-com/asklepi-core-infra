locals {
  environment = "prod"

  project_id                                   = "asklepi-core-prod"
  service_account_project_id                   = "asklepi-core-prod"
  terraform_apply_service_account_id           = "tf-core-prod-apply"
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

  firebase = {
    database_id   = "(default)"
    database_type = "FIRESTORE_NATIVE"
    location_id   = "eur3"
  }

  functions = {
    function_name                  = "core-handler-prod"
    runtime_service_account_id     = "core-fn-runtime"
    ci_deployer_service_account_id = "core-fn-ci-deployer"
    runtime_secret_name            = "CORE_FUNCTION_RUNTIME_SECRET"
    runtime_project_roles          = ["roles/datastore.user"]
    ci_deployer_project_roles = [
      "roles/cloudfunctions.developer",
      "roles/run.developer",
      "roles/cloudbuild.builds.editor",
      "roles/artifactregistry.writer"
    ]

    deploy_enabled              = false
    function_runtime            = "nodejs22"
    function_entry_point        = "handler"
    github_repository           = "asklepi-com/asklepi-functions"
    function_source_bucket      = "asklepi-core-prod-functions-source"
    function_source_object      = "core-handler/prod/latest.zip"
    function_timeout_seconds    = 60
    function_available_memory   = "512M"
    function_min_instance_count = 0
    function_max_instance_count = 20
    function_ingress_settings   = "ALLOW_INTERNAL_AND_GCLB"
    function_environment_variables = {
      APP_ENV = "prod"
    }
    invoker_members = []
  }
}
