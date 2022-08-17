resource "google_storage_bucket" "gcs_repo" {
  name                        = local.gcs_repo_name
  project                     = var.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  force_destroy               = true
}


resource "google_storage_bucket_object" "gcs_content" {
  for_each = fileset("${path.module}/gcs_content", "**")
  bucket   = google_storage_bucket.gcs_repo.name
  name     = each.key
  source   = "${path.module}/gcs_content/${each.key}"
}


