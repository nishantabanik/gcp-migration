# Virtual machines
data "google_service_account" "compute" {
  project    = var.gcp_project_id
  account_id = "1004794860017-compute@developer.gserviceaccount.com"
}


# module "compute-sa-1" {
#   source     = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account"
#   project_id    = var.gcp_project_id
#   name       = "compute-sa-1"
#   # non-authoritative roles granted *to* the service accounts on other resources
#   iam_project_roles = {
#     "myproject" = [
#       "roles/logging.logWriter",
#       "roles/monitoring.metricWriter",
#       "roles/compute.instanceAdmin"
#     ]
#   }
# }

# VM for testing internal connectivity
module "vm-compile-master-1" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id    = var.gcp_project_id
  zone          = "${var.gcp_region}-a"
  name          = "vm-compile-master-1"
  instance_type = "e2-standard-4"

  boot_disk = {
    initialize_params = {
      # gcloud compute images list --project opensuse-cloud 
      image = "opensuse-cloud/opensuse-leap-15-6-v20250408-x86-64"
      size  = 50
    }
  }

  network_interfaces = [{
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }]
  service_account = data.google_service_account.compute.email
  depends_on      = [module.vpc]
  tags            = [local.swp_internet_access_tag]
  attached_disks = [
    {
      name = "data1"
      size = "100"
  }]

  metadata = {
    startup-script = <<-EOF
      #! /bin/bash
      #apt-get update
      #apt-get install -y nginx
    EOF
  }

}
