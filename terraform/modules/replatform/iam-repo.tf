resource "google_service_account_iam_binding" "enable_anthos_to_sa" {
  service_account_id = google_service_account.repo_admin.id
  role               = "roles/iam.workloadIdentityUser"
  members = [ "serviceAccount:${var.project_id}.svc.id.goog[config-management-system/root-reconciler]" ]
}

resource "google_service_account" "repo_admin" {
  project       = var.project_id
  account_id    = "anthos-repo-admin"
  display_name  = "Service Account for the webapp"
}

resource "google_project_iam_member" "repo_admin_role" {
  project = var.project_id
  role    = "roles/source.admin"
  member  = "serviceAccount:${google_service_account.repo_admin.email}"
}
