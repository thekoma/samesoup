# # I need a SVC account in IAM that has the right roles to work with the repository
resource google_service_account "gcs_kanboard" {
  project       = var.project_id
  account_id    = var.gcs_kanboard_svc_account_id
  display_name  = "Service Account for the webapp to save the images"
}

resource "google_storage_hmac_key" "hmac_secret" {
  project = var.project_id
  service_account_email = google_service_account.gcs_kanboard.email
}

resource "google_project_iam_member" "rehost-object-admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gcs_kanboard.email}"
}