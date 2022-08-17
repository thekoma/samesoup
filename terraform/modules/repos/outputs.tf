output hmac_secret_id {
  value = google_storage_hmac_key.hmac_secret.access_id
}

output hmac_secret_key {
  value = google_storage_hmac_key.hmac_secret.secret
}

output gcs_repo_name {
  value = google_storage_bucket.gcs_repo.name
}

output gcs_repo_url {
  value = google_storage_bucket.gcs_repo.url
}
output config_php {
  value = data.template_file.config_php.rendered
}

output php_config_secret_id {
  value = var.php_config_secret_id
}

output gcs_repo_url_secret_id {
  value = var.gcs_repo_url_secret_id
}


output gcs_repo_name_secret_id {
  value = var.gcs_repo_name_secret_id
}
