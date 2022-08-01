
resource "google_compute_network" "main-network" {
  name = var.network_name
  project       = module.project-factory.project_id
}

resource "google_compute_global_address" "private_ip_alloc" {
  project       = module.project-factory.project_id
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main-network.id
}

resource "google_service_networking_connection" "service_net" {
  network                 = google_compute_network.main-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

data "google_compute_subnetwork" "sub_nat_net" {
  name        = var.subnetwork
  project     = module.project-factory.project_id
  region      = var.region
}



resource "google_compute_router" "nat_router" {
  name    = "${var.network_name}-router"
  project = module.project-factory.project_id
  region  = var.region
  network = google_compute_network.main-network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = resource.google_compute_router.nat_router.name
  project                            = module.project-factory.project_id
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta
  project       = module.project-factory.project_id
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main-network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta
  network                 = google_compute_network.main-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [ google_compute_global_address.private_ip_address.name ]
}


