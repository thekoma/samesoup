resource "google_storage_bucket" "utils" {
  name          = "utils"
  project       = module.project-factory.project_id
  location      = "US"
}
