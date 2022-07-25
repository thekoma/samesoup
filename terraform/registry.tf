resource "google_artifact_registry_repository" "demo-repo" {
  project       = module.project-factory.project_id
  depends_on    = [module.enabled_google_apis]
  provider      = google-beta
  location      = var.region
  repository_id = module.project-factory.project_name
  description   = "Demo Registry"
  format        = "DOCKER"
}


