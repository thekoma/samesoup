locals {
  anthos_repo_name = "anthos-repo-${var.project_id}"
}

resource "google_sourcerepo_repository" "anthos_repo" {
  depends_on = [ module.enabled_google_apis ]
  project = var.project_id
  name = local.anthos_repo_name
}