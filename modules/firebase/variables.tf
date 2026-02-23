variable "project_id" {
  description = "GCP project id where Firebase/Firestore is configured."
  type        = string
}

variable "database_id" {
  description = "Firestore database id. Use '(default)' for the primary database."
  type        = string
  default     = "(default)"
}

variable "database_type" {
  description = "Firestore database type."
  type        = string
  default     = "FIRESTORE_NATIVE"
}

variable "location_id" {
  description = "Firestore location. Multi-region eur3 keeps data in EU."
  type        = string
  default     = "eur3"
}

variable "required_services" {
  description = "APIs required for Firebase + Firestore provisioning."
  type        = set(string)
  default = [
    "firebase.googleapis.com",
    "firestore.googleapis.com"
  ]
}
