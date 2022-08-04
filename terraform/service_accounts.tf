resource "google_service_account" "rehost" {
  project       = module.project-factory.project_id
  account_id    = "rehost"
  display_name  = "rehost"
}
resource "google_service_account" "rehost-mig" {
  project       = module.project-factory.project_id
  account_id    = "rehost-mig"
  display_name  = "rehost-mig"
}
resource "google_service_account" "replatform" {
  project       = module.project-factory.project_id
  account_id    = "replatform"
  display_name  = "replatform"
}
resource "google_service_account" "refactor" {
  project       = module.project-factory.project_id
  account_id    = "refactor"
  display_name  = "refactor"
}