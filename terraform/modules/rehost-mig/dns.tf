

data "google_dns_managed_zone" "dns_zone" {
  name    = var.dns_zone
  project = var.dns_project_id
}

locals {
  rehost_record = "${var.vm_name}.${var.dns_prefix}.${data.google_dns_managed_zone.dns_zone.dns_name}"
}

resource "google_dns_record_set" "rehost-mig" {
  depends_on    = [ module.enabled_google_apis ]
  project       = var.dns_project_id
  name          = local.rehost_record
  managed_zone  = data.google_dns_managed_zone.dns_zone.name
  type          = "A"
  ttl           = 300
  rrdatas       = [ module.mig_lb_https.external_ip ]
}
