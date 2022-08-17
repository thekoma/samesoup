resource google_service_account "rehost" {
  project       = var.project_id
  account_id    = var.service_account_id
  display_name  = "Service Account for the rehost VM"
}

resource "google_project_iam_member" "rehost_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.rehost.email}"
}

resource "google_secret_manager_secret_iam_member" "php_config_secret_id" {
  project   = var.project_id
  secret_id = var.php_config_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.rehost.email}"
}

resource "google_secret_manager_secret_iam_member" "gcs_repo_url" {
  project   = var.project_id
  secret_id = var.gcs_repo_url_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.rehost.email}"
}

resource "google_secret_manager_secret_iam_member" "gcs_repo_name" {
  project   = var.project_id
  secret_id = var.gcs_repo_name_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.rehost.email}"
}
