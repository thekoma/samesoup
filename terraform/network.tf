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