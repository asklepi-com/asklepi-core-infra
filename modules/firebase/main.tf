resource "google_project_service" "required" {
  for_each = var.required_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_firestore_database" "db" {
  project     = var.project_id
  name        = var.database_id
  type        = var.database_type
  location_id = var.location_id

  depends_on = [google_project_service.required]
}
