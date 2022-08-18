data "google_dns_managed_zone" "dns_zone" {
  name    = var.dns_zone
  project = var.dns_project_id
}


resource "google_dns_record_set" "replatform" {
  name          = "replatform.${local.basename}"
  project       = var.dns_project_id
  managed_zone  = data.google_dns_managed_zone.dns_zone.name
  type          = "A"
  ttl           = 300
  rrdatas       = [ google_compute_global_address.replatform.address ]
}

