locals {
  role_bindings = flatten([
    for project_id, roles in var.target_project_roles : [
      for role in roles : {
        project_id = project_id
        role       = role
      }
    ]
  ])

  role_binding_map = {
    for binding in local.role_bindings :
    "${binding.project_id}:${binding.role}" => binding
  }
}

resource "google_service_account" "terraform_apply" {
  project      = var.service_account_project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

resource "google_project_iam_member" "terraform_apply_roles" {
  for_each = local.role_binding_map

  project = each.value.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.terraform_apply.email}"
}

resource "google_service_account_iam_member" "github_wif_user" {
  service_account_id = google_service_account.terraform_apply.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${var.workload_identity_pool_name}/attribute.repository/${var.github_repository}"
}
