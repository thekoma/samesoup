data "google_service_account" "rehost" {
  account_id = var.service_account_id
}

resource "google_compute_instance" "rehost" {
  name          = "rehost"
  machine_type  = "e2-medium"
  zone          = var.primary-zone
  project       = var.project_id
  allow_stopping_for_update = true
  service_account {
    email  = data.google_service_account.rehost.email
    scopes = ["compute-ro", "storage-rw", "logging-write", "monitoring-write", "service-control", "service-management", "pubsub", "trace", "cloud-platform"]
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size = "100"
    }
  }
  network_interface {
    network     = var.network
    subnetwork  = var.subnetwork
    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = "echo hi > /test.txt"
  tags = var.tags
}


output "instance_ip_addr" {
  value = google_compute_instance.rehost.network_interface.0.access_config.0.nat_ip
}