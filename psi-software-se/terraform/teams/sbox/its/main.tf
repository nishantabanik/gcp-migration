module "zistestvpc" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc?ref=stable"
  project_id = var.gcp_project_id
  name       = "zistestvpc"              # REQUIRED: This is the VPC name

  # Optional settings (you can customize further)
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  routing_mode                    = "GLOBAL"
  description                     = "Custom VPC created by Terraform"

  subnets = [
    {
      name          = "subnet-01"
      region        = var.gcp_region
      ip_cidr_range = "10.10.0.0/24"
    }
  ]

  # Example DNS policy (optional)
  dns_policy = {
    inbound  = true
    logging  = false
    outbound = {
      private_ns = ["8.8.8.8"]
      public_ns  = ["1.1.1.1"]
    }
  }
  
}
module "zistestvm" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id = var.gcp_project_id
  name       = "zistestvm"
  zone       = var.gcp_zone

  instance_type = "e2-medium"
  tags = ["ssh", "http", "https","allow-outbound"]  # <--- Add firewall tags here

  network_interfaces = [
  {
    network    = module.zistestvpc.network.self_link
    subnetwork = module.zistestvpc.subnet_self_links["${var.gcp_region}/subnet-01"]
    nat        = false # prevent external IP
    addresses  = {}
    alias_ips  = {}
    nic_type   = null
  }
]

  boot_disk = {
    auto_delete = true
    initialize_params = {
      image = "projects/debian-cloud/global/images/family/debian-11"
      size  = 10
      type  = "pd-balanced"
    }
  }

  service_account_create = true
}
module "firewall_rules" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc-firewall?ref=stable"
  project_id = var.gcp_project_id
  network    = module.zistestvpc.name

  default_rules_config = {
    ssh_ranges   = ["0.0.0.0/0"]
    ssh_tags     = ["ssh"]
    http_ranges  = ["0.0.0.0/0"]
    http_tags    = ["http"]
    https_ranges = ["0.0.0.0/0"]
    https_tags   = ["https"]
    admin_ranges = ["10.10.0.0/24"]

    # Explicit outbound rule allowing traffic to the internet.
    egress_ranges = ["0.0.0.0/0"]
    egress_tags   = ["allow-outbound"]
  }
}
