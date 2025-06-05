module "nat" {
  source         = "git@gitlab.com:psi-software-se/terraform/modules.git//net-cloudnat?ref=stable"
  name           = "nat"
  project_id     = var.gcp_project_id
  region         = var.gcp_region
  router_network = module.vpc.name
}