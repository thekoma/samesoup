resource "google_secret_manager_secret_iam_binding" "rehost_record" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.rehost_record.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}
resource "google_secret_manager_secret_iam_binding" "kanban_password" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.kanban_password.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}
resource "google_secret_manager_secret_iam_binding" "hmac_secret_key" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.hmac_secret_key.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}
resource "google_secret_manager_secret_iam_binding" "hmac_secret_id" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.hmac_secret_id.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "bucket_id" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.bucket_id.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "db_host" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.db_host.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "secret_key" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.secret_key.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}
resource "google_secret_manager_secret_iam_binding" "postgres_db_name" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgres_db_name.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}
resource "google_secret_manager_secret_iam_binding" "postgres_user" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgres_user.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}
resource "google_secret_manager_secret_iam_binding" "postgres_password" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgres_password.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}",
    "serviceAccount:${google_service_account.rehost-mig.email}"
  ]
}
