module "gcp-network" {
  source                    = "terraform-google-modules/network/google"
  version                   = "~> 5.1.0"

  project_id                = module.project-factory.project_id
  network_name              = var.network_name
  # private_ip_google_access  = true # TODO
  subnets                   = [
                                {
                                  subnet_name   = var.subnetwork
                                  subnet_ip     = var.subnet_ip
                                  subnet_region = var.region
                                }
                              ]

  secondary_ranges          = {
                                (var.subnetwork) = [
                                  {
                                    range_name    = var.ip_range_pods_name
                                    ip_cidr_range = var.pods_subnet_ip
                                  },
                                  {
                                    range_name    = var.ip_range_services_name
                                    ip_cidr_range = var.svcs_subnet_ip
                                  },
                                ]
                              }
}

data "google_compute_subnetwork" "sub_nat_net" {
  depends_on  = [ module.gcp-network ]
  name        = var.subnetwork
  project     = module.project-factory.project_id
  region      = var.region
}

data "google_compute_network" "nat_net" {
  depends_on  = [ module.gcp-network ]
  name        = var.network_name
  project     = module.project-factory.project_id
}

resource "google_compute_router" "nat_router" {
  name    = "${var.network_name}-router"
  project = module.project-factory.project_id
  region  = var.region
  network = data.google_compute_network.nat_net.id

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

# data "google_compute_network" "subnet-vm" {
#   project             = module.project-factory.project_id
#   name = var.network_name
# }

# resource "google_compute_global_address" "private_ip_address" {
#   # provider      = google-beta
#   project       = module.project-factory.project_id
#   name          = "private-ip-address"
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   prefix_length = 16
#   network       = data.google_compute_network.subnet-vm.id
# }

# resource "google_service_networking_connection" "private_vpc_connection" {
#   # provider = google-beta
#   network                 = data.google_compute_network.subnet-vm.id
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [ google_compute_global_address.private_ip_address.name ]
# }

# resource "random_id" "db_name_suffix" {
#   byte_length = 4
# }



resource "google_compute_network" "peering_network" {
  name = "peering-network"
  project       = module.project-factory.project_id
}

resource "google_compute_global_address" "private_ip_alloc" {
  project       = module.project-factory.project_id
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.peering_network.id
}

resource "google_service_networking_connection" "foobar" {
  network                 = google_compute_network.peering_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}