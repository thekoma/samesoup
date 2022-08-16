resource "google_sourcerepo_repository" "anthos_repo" {
  project = var.project_id
  name = "anthos-repo-${data.google_project.project.name}"
}

resource "null_resource" "align_repo_from_template" {
  triggers = {
    # Trigger wlways
    always_run = "${timestamp()}"

    # Trigger only on playbook changes
    # dir_sha1 = sha1(join("", [for f in fileset("${path.module}/ansible", "**"): filesha1("${path.module}/ansible/${f}")]))
  }

  provisioner "local-exec" {
      command = "ansible-playbook -vv ${path.module}/ansible/playbook.yaml"
      environment = {
        TEMPLATE_GIT = "${var.template_git}"
        TEMPLATE_PATH = "${var.template_path}"
        PROJECT_GIT = "${google_sourcerepo_repository.anthos_repo.name}"
        PROJECT_ID = "${var.project_id}"
        CUSTOM_METRICS_SA = "${google_service_account.metrics_adapter.email}"
        KANBOARD_SA = "${data.google_service_account.replatform.email}"
        REPO_SA = "${google_service_account.repo_admin.email}"
        EXTERNAL_SECRET_PATH="secondary/external-secrets"
        EXTERNAL_KANBOARD_PATH="secondary/kanboard"
        SSL_DOMAIN="replatform.${trimsuffix(local.basename, ".")}"
        KANBOARD_IMAGE="${var.region}-docker.pkg.dev/${var.project_id}/${var.project_id}/kanboard"
        KANBOARD_TAG="latest"
      }
  }
}

resource "google_artifact_registry_repository" "demo-repo" {
  project       = var.project_id
  provider      = google-beta
  location      = var.region
  repository_id = var.project_id
  description   = "Demo Registry"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "build-kanboard-image" {
  depends_on = [ null_resource.align_repo_from_template, google_artifact_registry_repository.demo-repo ]
  project = var.project_id
  name = "kanboard-build-trigger"
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.anthos_repo.name
  }
  substitutions = {
      _REGISTRY = "${var.region}-docker.pkg.dev/${var.project_id}/${var.project_id}"
  }
  filename = "cloudbuild.yaml"
}

data google_service_account "gke_svc_account" {
  project = var.project_id
  account_id = module.gke.service_account
}

resource "google_artifact_registry_repository_iam_binding" "pull-permissions" {
  project = var.project_id
  location = var.region
  repository = google_artifact_registry_repository.demo-repo.name
  role = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:${data.google_service_account.replatform.email}",
    "serviceAccount:${data.google_service_account.gke_svc_account.email}"
  ]
}