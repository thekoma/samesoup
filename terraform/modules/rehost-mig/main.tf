# # I need a SVC account in IAM that has the right roles to work with the repository


module "rehost_mig_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "~> 7.8.0"
  service_account = {
    email  = google_service_account.rehost_mig.email
    scopes = var.scopes
  }


  machine_type              = var.machine_type
  region                    = var.region
  project_id                = var.project_id
  source_image_project      = var.image_project
  source_image_family       = var.image_family
  name_prefix               = var.vm_name_prefix
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
        - gsutil rsync -r ${var.gcs_repo_url} /opt/installer/
        - ansible-galaxy collection install community.postgresql maxhoesel.caddy community.general
        - ansible-galaxy install googlecloudplatform.google_cloud_ops_agents
        - ansible-playbook /opt/installer/ansible/rerun.yaml --extra-vars "gcs_repo=${var.gcs_repo_url} php_config_secret_id=${var.php_config_secret_id}"
        - sh -c /opt/installer/rerun.sh
      EOT
  }
}

module "rehost_mig" {
  source              = "terraform-google-modules/vm/google//modules/mig"
  version              = "~> 7.8.0"
  instance_template   = module.rehost_mig_template.self_link
  region              = var.region
  autoscaling_enabled = true
  min_replicas        = var.min_replicas
  max_replicas        = var.max_replicas
  project_id          = var.project_id
  hostname            = var.vm_name
  health_check_name   = "${var.vm_name}-http"
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

locals {
  lb_ssl_domains = [
    local.rehost_record
  ]
}
module "mig_lb_https" {
  source                          = "GoogleCloudPlatform/lb-http/google"
  version                         = "~> 6.3"
  name                            = "${var.vm_name}-lb"
  project                         = var.project_id
  target_tags                     = var.tags
  firewall_networks               = [ var.network ]
  ssl                             = true
  use_ssl_certificates            = false
  managed_ssl_certificate_domains = local.lb_ssl_domains
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
          group                        = module.rehost_mig.instance_group
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