resource "google_storage_bucket" "utils" {
  name                        = "utils-${random_string.suffix.result}"
  project                     = module.project-factory.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  force_destroy               = true
}


resource "google_storage_bucket_object" "gcs_content" {
  for_each = fileset("${path.module}/../gcs_content", "**")
  bucket   = google_storage_bucket.utils.name
  name     = "${each.key}"
  source   = "${path.module}/../gcs_content/${each.key}"
}


resource "google_project_iam_member" "rehost-object-admin" {
  project = module.project-factory.project_id
  role    = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.rehost.email}"
}

resource "google_storage_hmac_key" "hmac_secret" {
  project = module.project-factory.project_id
  service_account_email = google_service_account.rehost.email
  depends_on = [ module.policies ]
}