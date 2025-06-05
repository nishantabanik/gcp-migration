# Virtual machines
data "google_service_account" "compute" {
  project    = var.gcp_project_id
  account_id = "compute-1"
}

# VM for testing internal connectivity
module "vm-1" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id = var.gcp_project_id
  zone       = "${var.gcp_region}-a"
  name       = "vm-1"
  network_interfaces = [{
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }]
  service_account        = data.google_service_account.compute.email
  service_account_scopes = ["cloud-platform"]
  depends_on             = [module.vpc]
  tags                   = [local.swp_internet_access_tag]

}

# VM for bootstrapping RKE
module "bootstrap-1" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id = var.gcp_project_id
  zone       = "${var.gcp_region}-a"
  name       = "bootstrap-1"
  network_interfaces = [{
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }]
  service_account        = data.google_service_account.compute.email
  service_account_scopes = ["cloud-platform"]
  depends_on             = [module.vpc]
}
