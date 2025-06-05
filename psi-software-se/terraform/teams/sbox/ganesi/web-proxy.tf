resource "google_compute_address" "swp_address" {
  name         = "secure-web-proxy-internet"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.subnet_self_links["${var.gcp_region}/${var.gcp_subnetwork}"]
}

module "secure-web-proxy" {
  # TODO should be moved to https://gitlab.com/psi-software-se/terraform/modules
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-swp?ref=v39.0.0&depth=1"
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
    allowall = {
      priority        = 900
      session_matcher = "true" # erlaubt alle Ziele
    }
    gitlab = {
      priority = 1000
      # access to gitlab.com (our own repos) and github.io for Helm Charts
      session_matcher = <<-EOT
        host().endsWith('gitlab.com') ||
        host().endsWith('github.io') ||
        host().endsWith('github.io') ||
        host().endsWith('cloudfront.com') ||
        host().endsWith('cloudflare.com') ||
        host().endsWith('mirror.de.leaseweb.net') ||
        host().endsWith('opensuse.org')
      EOT
    }
  }
}

resource "google_compute_route" "default" {
  name         = "default-swp-route"
  dest_range   = "0.0.0.0/0"
  network      = var.gcp_network
  next_hop_ilb = google_compute_address.swp_address.address
  priority     = 100
  tags         = [local.swp_internet_access_tag]
}

