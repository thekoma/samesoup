resource "random_password" "secret_key" {
  length           = 32
  special          = false
}

resource "google_secret_manager_secret" "secret_key" {
  project = module.project-factory.project_id
  secret_id = "secret-key"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "secret_key" {
  secret = google_secret_manager_secret.secret_key.id
  secret_data = random_password.secret_key.result
}



resource "random_password" "kanban_password" {
  length           = 16
  special          = false
}

resource "google_secret_manager_secret" "kanban_password" {
  project = module.project-factory.project_id
  secret_id = "kanban_password"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "kanban_password" {
  secret = google_secret_manager_secret.kanban_password.id
  secret_data = random_password.kanban_password.result
}