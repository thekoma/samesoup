# output "ssh_private_key" {
#   value = tls_private_key.repo-admin-private-key.private_key_pem
# }

# output "ssh_public_key" {
#   value = data.tls_public_key.repo-admin-pub-key.public_key_openssh
# }
output "sync_repo" {
  value = google_sourcerepo_repository.anthos-repo.url
}

output "sync_sa" {
  value = google_service_account.repo-admin.id
}