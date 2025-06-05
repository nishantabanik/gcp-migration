variable "runner_token" {
  type = string
  description = "GitLab Runner Token"
}

module "gitlab-runner-vm" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id    = var.gcp_project_id
  zone          = "${var.gcp_region}-a"
  name          = "vm-gitlab-runner"
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
      name = "data-gitlab-runner"
      size = "50"
  }]

  metadata = {
    RUNNER_TOKEN = var.runner_token
    startup-script = templatefile("${path.module}/templates/gitlab-runner-init.sh", {})
  }

}
