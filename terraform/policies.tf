resource "google_project_organization_policy" "vmExternalIpAccess" {
  project     = module.project-factory.project_id
  constraint = "compute.vmExternalIpAccess"
  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "requireShieldedVm" {
  project     = module.project-factory.project_id
  constraint = "compute.requireShieldedVm"
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "requireOsLogin" {
  project     = module.project-factory.project_id
  constraint = "compute.requireOsLogin"
  boolean_policy {
    enforced = false
  }
}


resource "google_project_organization_policy" "vmCanIpForward" {
  project     = module.project-factory.project_id
  constraint = "compute.vmCanIpForward"
  list_policy {
    allow {
      all = true
    }
  }
}

