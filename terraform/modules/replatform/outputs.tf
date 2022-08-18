output "sync_repo" {
  value = google_sourcerepo_repository.anthos_repo.url
}

output "registry_name" {
  value = google_artifact_registry_repository.registry.name
}
