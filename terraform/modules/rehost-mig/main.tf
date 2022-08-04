data "google_service_account" "rehost" {
  account_id = var.service_account_id
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
  target_size         = 3
  project_id          = var.project_id
  hostname            = "rehost-mig"
  health_check_name = "rehost-mig-http"
  health_check = {
    type                = "http"
    initial_delay_sec   = 120
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 30
    unhealthy_threshold = 10
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = ""
  }
}