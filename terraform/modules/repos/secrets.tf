resource "google_secret_manager_secret" "config_php" {
  project = var.project_id
  secret_id = var.php_config_secret_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "config_php" {
  secret = google_secret_manager_secret.config_php.id
  secret_data = data.template_file.config_php.rendered
}

### GCS compatible S3 Credentials
resource "google_secret_manager_secret" "hmac_secret_id" {
  project = var.project_id
  secret_id = var.hmac_secret_id_secret_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}
resource "google_secret_manager_secret_version" "hmac_secret_id" {
  secret = google_secret_manager_secret.hmac_secret_id.id
  secret_data = google_storage_hmac_key.hmac_secret.access_id
}

resource "google_secret_manager_secret" "hmac_secret_key" {
  project = var.project_id
  secret_id = var.hmac_secret_key_secret_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "hmac_secret_key" {
  secret = google_secret_manager_secret.hmac_secret_key.id
  secret_data = google_storage_hmac_key.hmac_secret.secret
}


resource "google_secret_manager_secret" "gcs_repo_url" {
  project = var.project_id
  secret_id = var.gcs_repo_url_secret_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "gcs_repo_url" {
  secret = google_secret_manager_secret.gcs_repo_url.id
  secret_data = google_storage_bucket.gcs_repo.url
}

resource "google_secret_manager_secret" "gcs_repo_name" {
  project = var.project_id
  secret_id = var.gcs_repo_name_secret_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "gcs_repo_name" {
  secret = google_secret_manager_secret.gcs_repo_name.id
  secret_data = google_storage_bucket.gcs_repo.name
}

