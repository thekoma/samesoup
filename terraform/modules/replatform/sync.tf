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
        KANBOARD_SA = "${google_service_account.kanboard_sa.email}"
        SSL_DOMAIN="replatform.${trimsuffix(local.basename, ".")}"
        KANBOARD_IMAGE="${local.registry}/kanboard"
        KANBOARD_TAG="latest"
        SECRET_ID="${var.php_config_secret_id}"
      }
  }
}
