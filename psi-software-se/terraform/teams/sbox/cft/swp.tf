resource "google_compute_address" "swp_address" {
  name         = "secure-web-proxy-internet"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.subnet_self_links["${var.gcp_region}/${var.gcp_subnetwork}"]
}

resource "google_compute_route" "default" {
  name         = "default-swp-route"
  dest_range   = "0.0.0.0/0"
  network      = var.gcp_network
  next_hop_ilb = google_compute_address.swp_address.address
  priority     = 100
  tags         = [local.swp_internet_access_tag]
}

module "secure-web-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-swp?ref=stable"
  project_id = var.gcp_project_id
  region     = var.gcp_region
  name       = "secure-web-proxy-internet"
  network    = module.vpc.id
  subnetwork = module.vpc.subnet_self_links["${var.gcp_region}/${var.gcp_subnetwork}"]
  gateway_config = {
    addresses             = [google_compute_address.swp_address.address] # SWP allows only providing unreserved addresses, must provide address to avoid drift
    next_hop_routing_mode = true
    ports                 = [80, 443] # specify all ports to be intercepted
  }
  policy_rules = {
    docker-hub = {
      priority = 1000
      session_matcher = "host().endsWith('docker.io')"
    }
    github = {
      priority = 1001
      session_matcher = "host().endsWith('ghcr.io') || host().endsWith('githubusercontent.com') || host().endsWith('github.io')"
    }
    quay = {
      priority = 1002
      session_matcher = "host().endsWith('quay.io')"
    }
    gitlab = {
      priority = 1003
      session_matcher = "host().endsWith('gitlab.com')"
    }
  }
}

