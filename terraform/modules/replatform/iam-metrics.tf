# ### Custom Metrics Adapter ###
# resource "google_service_account" "metrics_adapter" {
#   project       = var.project_id
#   account_id    = "metrics-adapter"
#   display_name  = "Service Account for the metrics adapter"
# }

# resource "google_project_iam_member" "metrics_adapter" {
#   project = var.project_id
#   role    = "roles/source.admin"
#   member  = "serviceAccount:${google_service_account.metrics_adapter.email}"
# }

# resource "google_service_account_iam_binding" "metrics_adapter" {
#   service_account_id = google_service_account.metrics_adapter.id
#   role               = "roles/iam.workloadIdentityUser"
#   members = [ "serviceAccount:${var.project_id}.svc.id.goog[custom-metrics/custom-metrics-stackdriver-adapter]" ]
# }

# resource "google_project_iam_member" "metrics_adapter_monitor_view" {
#   project = var.project_id
#   role    = "roles/monitoring.admin"
#   member  = "serviceAccount:${google_service_account.metrics_adapter.email}"
# }
