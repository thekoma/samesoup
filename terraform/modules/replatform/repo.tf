resource "google_sourcerepo_repository" "anthos_repo" {
  project = var.project_id
  name = "anthos-repo-${data.google_project.project.name}"
}

resource "null_resource" "align_repo_from_template" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
      command = "ansible-playbook -vv ${path.module}/ansible/playbook.yaml"
      environment = {
        TEMPLATE_GIT = "${var.template_git}"
        TEMPLATE_PATH = "${var.template_path}"
        PROJECT_GIT = "${google_sourcerepo_repository.anthos_repo.name}"
        PROJECT_ID = "${var.project_id}"
        CUSTOM_METRICS_SA = "${google_service_account.metrics_adapter.email}"
      }
  }
}
