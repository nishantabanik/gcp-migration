module "vm-1" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id = var.gcp_project_id
  zone       = var.gcp_zone
  name       = "vm-1"
  network_interfaces = [{
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }]
  service_account        = data.google_service_account.compute.email
  service_account_scopes = ["cloud-platform"]
  tags                   = [local.swp_internet_access_tag]
  iam = {
    "roles/compute.osAdminLogin" = [
      "group:app-gcp-cft@psi.de"
    ]
  }
}
