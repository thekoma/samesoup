### Custom Metrics Adapter ###
resource google_service_account "refactor_sa" {
  project       = var.project_id
  account_id    = var.refactor_sa_name
  display_name  = "Service Account for the Kanboard Deployment Binding"
}

resource "google_secret_manager_secret_iam_member" "php_config_secret_id" {
  project   = var.project_id
  secret_id = var.php_config_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.refactor_sa.email}"
}


resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_service.refactor.location
  project = google_cloud_run_service.refactor.project
  service = google_cloud_run_service.refactor.name
  role = "roles/run.invoker"
  member = "allUsers"
}
