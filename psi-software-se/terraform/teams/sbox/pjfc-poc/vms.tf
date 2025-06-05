module "simple-vm-example" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id = var.gcp_project_id # e.g: "psi-de-0-example-1" 
  zone       = var.gcp_zone # e.g. "europe-west3-b"
  name       = "simple-vm-example-pjfc"
  network_interfaces = [{
    network    = var.gcp_network # For shared VPC: "projects/psi-de-0-dev-net-spoke-0/global/networks/dev-spoke-0" 
    subnetwork = var.gcp_subnetwork # For shared VPC: "projects/psi-de-0-dev-net-spoke-0/regions/europe-west3/subnetworks/dev-default-ew3"
  }]
  service_account = data.google_service_account.apps_sa.email # e.g.: ["serviceAccount:compute-1@psi-de-0-example-1.iam.gserviceaccount.com"]
  service_account_scopes = ["cloud-platform"]
  iam = {
    "roles/compute.osLogin" = [
      "group:app-gcp-sbox-pjfc-poc@psi.de"
    ],
    "roles/compute.osAdminLogin" = [
      "group:app-gcp-sbox-pjfc-poc-admins@psi.de"
    ]
  }
}