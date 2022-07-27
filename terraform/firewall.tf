resource "google_compute_firewall" "enable_iap" {
  project     = module.project-factory.project_id
  name        = "permit-iap"
  network     = module.gcp-network.network_id
  description = "Permit SSH and RDP to hosts via IAP"

  allow {
    protocol  = "tcp"
    ports     = ["22", "3389"]
  }
  source_ranges = [ "35.235.240.0/20" ]
  target_tags = ["ssh", "rdp"]
}

resource "google_compute_firewall" "enable_http_https" {
  project     = module.project-factory.project_id
  name        = "permit-http-https"
  network     = module.gcp-network.network_id
  description = "Permit HTTP/S to hosts"

  allow {
    protocol  = "tcp"
    ports     = ["80", "443"]
  }
  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["http", "https"]
}

resource "google_compute_firewall" "google_probes" {
  project     = module.project-factory.project_id
  name        = "permit-google-probes"
  network     = module.gcp-network.network_id
  description = "Permit HTTP/S to hosts"
  allow {
    protocol  = "all"
  }
  source_ranges = [ "130.211.0.0/22", "35.191.0.0/16" ]
}
