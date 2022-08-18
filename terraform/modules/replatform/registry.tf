resource "google_artifact_registry_repository" "registry" {
  depends_on = [ module.enabled_google_apis ]
  project       = var.project_id
  provider      = google-beta
  location      = var.region
  repository_id = var.project_id
  description   = "Registry"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "build-kanboard-image" {
  depends_on = [
    module.enabled_google_apis,
    null_resource.align_repo_from_template,
    google_artifact_registry_repository.registry
    ]
  project = var.project_id
  name = "kanboard-build-trigger"
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.anthos_repo.name
  }
  substitutions = {
      _REGISTRY = local.registry
  }
  filename = "cloudbuild.yaml"
}