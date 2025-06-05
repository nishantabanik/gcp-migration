module "rke_vm_template" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id = var.gcp_project_id
  zone       = "${var.gcp_region}-a"
  name       = "rke-template"
  tags       = ["rke"]
  instance_type = "e2-standard-4"
  network_interfaces = [{
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }]
  boot_disk = {
    initialize_params    = {
      size = 50
    }
  }
  service_account = data.google_service_account.compute.email
  service_account_scopes = ["cloud-platform"]
  depends_on = [ module.vpc ]

  create_template = true
}

module "rke_mig" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/compute-mig?ref=v38.1.0"
  
  project_id = var.gcp_project_id
  name       = "rke-cluster"
  location   = var.gcp_region
  
  named_ports = {
    "p9345" = 9345
    "p6443" = 6443
  }

  # Required parameters
  instance_template = module.rke_vm_template.template.self_link
  target_size       = 3
}

# Reserve an IP address for the load balancer
resource "google_compute_address" "internal_lb_ip" {
  name         = "rke-internal-lb-ip"
  subnetwork   = var.gcp_subnetwork
  address_type = "INTERNAL"
  purpose      = "SHARED_LOADBALANCER_VIP"
  region       = var.gcp_region
  address      = "10.0.0.39"
}

module "rke_ilb_6443" {
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-lb-proxy-int?ref=v38.1.0"
  project_id    = var.gcp_project_id
  region        = var.gcp_region
  name          = "ilb-rke-6443"
  vpc_config = {
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }
  backend_service_config = {
    port_name = "p6443"
    backends = [{
      group = module.rke_mig.group_manager.instance_group
    }]
  }
  health_check_config = {
    tcp = {
      port = 6443
    }
  }
  address = google_compute_address.internal_lb_ip.address
  port = 6443
}

module "rke_ilb_9345" {
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-lb-proxy-int?ref=v38.1.0"
  project_id    = var.gcp_project_id
  region        = var.gcp_region
  name          = "ilb-rke-9345"
  vpc_config = {
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }
  backend_service_config = {
    port_name = "p9345"
    backends = [{
      group = module.rke_mig.group_manager.instance_group
    }]
  }
  health_check_config = {
    tcp = {
      port = 9345
    }
  }
  address = google_compute_address.internal_lb_ip.address
  port = 9345
}
