data google_project "project" {
  project_id = var.project_id
}

resource "google_sourcerepo_repository" "anthos-repo" {
  project = var.project_id
  name = "anthos-repo-${data.google_project.project.name}"
}


resource "null_resource" "align-repo-from-template" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
      command = "ansible-playbook -v ${path.module}/ansible/playbook.yaml"
      environment = {
        TEMPLATE_GIT = "${var.template_git}"
        TEMPLATE_PATH = "${var.template_path}"
        PROJECT_GIT = "${google_sourcerepo_repository.anthos-repo.name}"
        PROJECT_ID = "${var.project_id}"
      }
  }
}