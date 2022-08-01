resource "random_password" "postgress_password" {
  length           = 16
  special          = false
}

resource "google_secret_manager_secret" "postgress_password" {
  project = module.project-factory.project_id
  secret_id = "postgress-password"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgress_password" {
  secret = google_secret_manager_secret.postgress_password.id
  secret_data = random_password.postgress_password.result
}

resource "google_secret_manager_secret_iam_binding" "postgress_password" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgress_password.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}

########


resource "google_secret_manager_secret" "postgres_user" {
  project = module.project-factory.project_id
  secret_id = "postgress-user"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgres_user" {
  secret = google_secret_manager_secret.postgres_user.id
  secret_data = local.postgres_user
}

resource "google_secret_manager_secret_iam_binding" "postgres_user" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgres_user.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}

########



resource "google_secret_manager_secret" "postgres_db_name" {
  project = module.project-factory.project_id
  secret_id = "postgress-db-name"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgres_db_name" {
  secret = google_secret_manager_secret.postgres_db_name.id
  secret_data = local.postgres_db_name
}

resource "google_secret_manager_secret_iam_binding" "postgres_db_name" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgres_db_name.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}

#######


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

resource "google_secret_manager_secret_iam_binding" "secret_key" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.secret_key.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}





resource "google_secret_manager_secret" "db_host" {
  project = module.project-factory.project_id
  secret_id = "db-host"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "db_host" {
  secret = google_secret_manager_secret.db_host.id
  secret_data = google_sql_database_instance.app-db.private_ip_address
}

resource "google_secret_manager_secret_iam_binding" "db_host" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.db_host.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}