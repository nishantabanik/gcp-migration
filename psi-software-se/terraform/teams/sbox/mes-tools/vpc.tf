module "vpc" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc?ref=psa"
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
      ip_cidr_range = "10.0.10.0/24"
      name          = "regional-proxy-ew3"
      region        = var.gcp_region
      active        = true
    }
  ]
  psa_config = {
    ranges = { cloud-sql = "10.60.0.0/16" }
  }
  subnets_psc = [
    {
      ip_cidr_range = "10.0.3.0/24"
      name          = "psc"
      region        = var.gcp_region
    }
  ]
}

module "dns-policy-googleapis" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//dns-response-policy?ref=stable"
  project_id = var.gcp_project_id
  name       = "googleapis"
  networks = {
    main = module.vpc.self_link
  }
  rules_file = "data/dns-policy-rules.yaml"
}
