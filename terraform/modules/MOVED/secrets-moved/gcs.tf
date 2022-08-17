resource "google_secret_manager_secret" "bucket_id" {
  project = module.project-factory.project_id
  secret_id = "bucket-id"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "bucket_id" {
  secret = google_secret_manager_secret.bucket_id.id
  secret_data = google_storage_bucket.utils.url
}