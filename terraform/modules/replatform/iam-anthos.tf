
data google_service_account "gke_svc_account" {
  project = var.project_id
  account_id = module.gke.service_account
}

resource "google_service_account" "anthos" {
  project       = var.project_id
  account_id    = "anthos"
  display_name  = "Service Account for anthos sync"
}

/* Connect the k8s sa to the service account */


/* Give the Source premission */
resource "google_project_iam_member" "repo_reader_anthos" {
  project = var.project_id
  role    = "roles/source.reader"
  member  = "serviceAccount:${google_service_account.anthos.email}"
}

resource "google_artifact_registry_repository_iam_binding" "pull_permissions" {
  project = var.project_id
  location = var.region
  repository = google_artifact_registry_repository.registry.name
  role = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:${data.google_service_account.gke_svc_account.email}"
  ]
}

resource "google_service_account_iam_binding" "anthos_workload_identity" {
  depends_on = [ module.gke ]
  service_account_id = google_service_account.anthos.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${local.identity_namespace}[config-management-system/root-reconciler]"
    ]
}