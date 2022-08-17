/* data "google_dns_managed_zone" "soup" {
  name    = var.dns_zone
  project = var.dns_project_id
}


resource "google_secret_manager_secret" "rehost_record" {
  project = module.project-factory.project_id
  secret_id = "rehost_record"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}
resource "google_secret_manager_secret_version" "rehost_record" {
  secret = google_secret_manager_secret.rehost_record.id
  secret_data = "rehost.${local.dns_basename}"
} */
