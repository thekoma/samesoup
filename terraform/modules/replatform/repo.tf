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
      }
  }
}
