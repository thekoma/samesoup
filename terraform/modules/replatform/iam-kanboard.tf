### Custom Metrics Adapter ###
data "google_service_account" "kanboard_sa" {
  project       = var.project_id
  account_id    = var.kanboard_sa_name_id
}

resource "google_service_account_iam_binding" "kanboard_sa" {
  service_account_id = data.google_service_account.kanboard_sa.id
  role               = "roles/iam.workloadIdentityUser"
  members = [ "serviceAccount:${var.project_id}.svc.id.goog[kanboard/kanboard]" ]
}
