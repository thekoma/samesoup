### Custom Metrics Adapter ###
resource google_service_account "kanboard_sa" {
  project       = var.project_id
  account_id    = var.kanboard_sa
  display_name  = "Service Account for the Kanboard Deployment Binding"
}

resource "google_service_account_iam_binding" "kanboard_workload_identity" {
  depends_on = [ module.gke ]
  service_account_id = google_service_account.kanboard_sa.id
  role               = "roles/iam.workloadIdentityUser"
  members = [ "serviceAccount:${var.project_id}.svc.id.goog[kanboard/kanboard]" ]
}

resource "google_secret_manager_secret_iam_member" "php_config_secret_id" {
  project   = var.project_id
  secret_id = var.php_config_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.kanboard_sa.email}"
}
