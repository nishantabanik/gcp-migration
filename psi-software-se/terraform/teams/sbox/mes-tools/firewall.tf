module "firewall" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc-firewall?ref=stable"
  project_id = var.gcp_project_id
  network    = var.gcp_network
  default_rules_config = {
    disabled = true
  }
  ingress_rules = {
   allow-ssh = {
      description = "Allow SSH"
      source_ranges = [
        "any"
      ]
      rules = [{ protocol = "tcp", ports = [22] }]
    }
    allow-https-in-gke-primary-subnet = {
      description = "Allow HTTPS in GKE primary subnet"
      source_ranges = [
        "any"
      ]
      rules = [{ protocol = "tcp", ports = [443] }]
    }
    allow-all-internal = {
      description   = "Allow all internal"
      source_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      rules         = [{ protocol = "all", ports = [] }]
    }

    allow-health-checks = {
      description = "Allow traffic from Google health checking for LB"
      source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
      rules = [{ protocol = "TCP", ports = [80, 6443, 9345] }]
    }
  }
  depends_on = [ module.vpc ]
}
