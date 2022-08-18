resource "google_project_organization_policy" "vmExternalIpAccess" {
  project     = var.project_id
  constraint = "compute.vmExternalIpAccess"
  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "requireShieldedVm" {
  project     = var.project_id
  constraint = "compute.requireShieldedVm"
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "requireOsLogin" {
  project     = var.project_id
  constraint = "compute.requireOsLogin"
  boolean_policy {
    enforced = false
  }
}
resource "google_project_organization_policy" "disableServiceAccountKeyCreation" {
  project     = var.project_id
  constraint = "constraints/iam.disableServiceAccountKeyCreation"
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "vmCanIpForward" {
  project     = var.project_id
  constraint = "compute.vmCanIpForward"
  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "allowedPolicyMemberDomains" {
  project     = var.project_id
  constraint = "iam.allowedPolicyMemberDomains"
  list_policy {
    allow {
      all = true
    }
  }
}
