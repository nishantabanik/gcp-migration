module "vpc" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc?ref=stable"
  project_id = var.gcp_project_id
  name       = var.gcp_network
  subnets = [
    {
      ip_cidr_range = "10.0.0.0/24"
      name          = var.gcp_subnetwork
      region        = var.gcp_region
      secondary_ip_ranges = {
        pods     = "172.16.0.0/20"
        services = "192.168.0.0/24"
      }
    }
  ]
  subnets_proxy_only = [
    {
      ip_cidr_range = "10.10.0.0/24"
      name          = "regional-proxy"
      region        = var.gcp_region
      active        = true
    }
  ]
}