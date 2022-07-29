resource "google_service_account" "webapp" {
  project       = var.project_id
  account_id    = "webapp"
  display_name  = "Service Account for the webapp"
}