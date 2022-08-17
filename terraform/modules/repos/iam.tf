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


# resource "google_service_account" "repo_admin" {
#   project       = var.project_id
#   account_id    = "anthos-repo-admin"
#   display_name  = "Service Account for the webapp"
# }

# # Connect the k8s sa to the service account
# resource "google_service_account_iam_binding" "enable_anthos_to_sa" {
#   service_account_id = google_service_account.repo_admin.id
#   role               = "roles/iam.workloadIdentityUser"
#   members = [
#     "serviceAccount:${var.project_id}.svc.id.goog[config-management-system/ns-reconciler-additional-configs-kanboard-8]",
#     "serviceAccount:${var.project_id}.svc.id.goog[config-management-system/ns-reconciler-additional-configs-external-secrets-16]",
#     "serviceAccount:${var.project_id}.svc.id.goog[config-management-system/root-reconciler]"
#     ]
# }

# # Give the Source premission
# resource "google_project_iam_member" "repo_admin_role" {
#   project = var.project_id
#   role    = "roles/source.admin"
#   member  = "serviceAccount:${google_service_account.repo_admin.email}"
# }
