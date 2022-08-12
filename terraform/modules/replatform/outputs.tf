output "sync_repo" {
  value = google_sourcerepo_repository.anthos_repo.url
}

output "sync_sa" {
  value = google_service_account.repo_admin.id
}

output "kanboard_sa_email" {
  value = google_service_account.kanboard_sa.email
}

output "pool_id" {
  value = module.gke.identity_namespace
}