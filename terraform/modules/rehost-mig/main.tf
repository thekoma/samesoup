data "google_service_account" "rehost" {
  account_id = var.service_account_id
}

data "google_compute_network" "main-network" {
  name = var.network
  project = var.project_id
}


# https://raw.githubusercontent.com/tapanbanker/terraform-ansible-gcp/master/main.tf
module "rehost-mig-template" {
  service_account = {
    email  = data.google_service_account.rehost.email
    scopes = ["compute-ro", "storage-rw", "logging-write", "monitoring-write", "service-control", "service-management", "pubsub", "trace", "cloud-platform"]
  }
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "~> 7.8.0"

  machine_type              = "e2-medium"
  region                    = var.region
  project_id                = var.project_id
  source_image_project      = "ubuntu-os-cloud"
  source_image_family       = "ubuntu-2204-lts"
  name_prefix               = "rehost-mig"
  tags                      = var.tags
  network                   = var.network
  subnetwork                = var.subnetwork
  enable_shielded_vm        = true
  metadata = {
    enable-oslogin = "TRUE"
    user-data      = <<EOT
        #cloud-config
        packages: ["ansible", "expect"]
        write_files:
        - path: /etc/ansible/ansible.cfg
          content: |
              [defaults]
              remote_tmp     = /tmp
              local_tmp      = /tmp
        runcmd:
        - mkdir -p /opt/installer/logs
        - gsutil cp -r ${var.gcs_ansible_url} /opt/installer
        - ansible-galaxy collection install community.postgresql maxhoesel.caddy community.general
        - ansible-galaxy install googlecloudplatform.google_cloud_ops_agents
        - ansible-playbook /opt/installer/ansible/rerun.yaml
        - sh -c /opt/installer/rerun.sh
      EOT
  }
}

module "rehost-mig" {
  source              = "terraform-google-modules/vm/google//modules/mig"
  version              = "~> 7.8.0"
  instance_template   = module.rehost-mig-template.self_link
  region              = var.region
  autoscaling_enabled = true
  min_replicas        = 1
  max_replicas        = 2
  project_id          = var.project_id
  hostname            = "rehost-mig"
  health_check_name = "rehost-mig-http"
  named_ports = [
    {
    name = "http"
    port = 8080
    }
  ]
  health_check = {
    type                = "http"
    initial_delay_sec   = 240
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 30
    unhealthy_threshold = 10
    response            = ""
    proxy_header        = "NONE"
    port                = 8080
    request             = ""
    request_path        = "/LICENSE"
    host                = ""
  }
}



module "mig-lb-https" {
  source                          = "GoogleCloudPlatform/lb-http/google"
  version                         = "~> 6.3"
  name                            = "mig-lb-https"
  project                         = var.project_id
  target_tags                     = [ data.google_compute_network.main-network.name  ]
  firewall_networks               = [ data.google_compute_network.main-network.name ]
  ssl                             = true
  use_ssl_certificates            = false
  managed_ssl_certificate_domains = var.lb_ssl_domains
  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 8080
      port_name                       = "http"
      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = 30
        timeout_sec         = 30
        healthy_threshold   = 1
        unhealthy_threshold = 10
        request_path        = "/LICENSE"
        port                = 8080
        host                = null
        logging             = true
      }

      log_config = {
        enable      = false
        sample_rate = null
      }

      groups = [
        {
          group                        = module.rehost-mig.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}

output "external_ip" {
  value = module.mig-lb-https.external_ip
}