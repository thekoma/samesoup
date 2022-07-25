resource "google_storage_bucket" "utils" {
  name                        = "utils-${random_string.suffix.result}"
  project                     = module.project-factory.project_id
  location                    = var.location
  uniform_bucket_level_access = true
}
