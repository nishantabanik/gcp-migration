# tfdoc:file:description Dev spoke VPC and related resources (DELETE ME).

#
# TODO: Remove this file after project psi-de-0-dev-net-spoke-0 is deleted!
#

module "dev-spoke-project" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//project?ref=stable"
  billing_account = var.billing_account.id
  name            = "dev-net-spoke-0"
  parent          = var.folder_ids.networking-dev
  prefix          = var.prefix
  services = [
    "container.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
    "vpcaccess.googleapis.com"
  ]
  shared_vpc_host_config = {
    enabled = true
  }
  metric_scopes = [module.landing-project.project_id]
}
