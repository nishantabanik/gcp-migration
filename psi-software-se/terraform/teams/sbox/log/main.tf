data "google_project" "self" {
  project_id = var.project_id
}

data "google_service_account" "apps_sa" {
  project    = var.project_id
  account_id = "apps-sa"
}

data "google_service_account" "kubernetes" {
  project    = var.project_id
  account_id   = "kubernetes-1"
}

data "google_service_account" "crossplane" {
  project    = var.project_id
  account_id   = "crossplane"
}

module "gke-cluster-main" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-cluster-autopilot?ref=stable"

  name       = "gke-cluster-main"
  project_id = var.project_id
  location   = var.region

  node_config = {
    service_account = data.google_service_account.kubernetes.email
    tags = [
      "health-check",
      "internal-http-server",
      "internal-https-server",
      "internal-tcp"
    ]
  }

  vpc_config = {
    network    = var.network
    subnetwork = var.subnetwork
    gcp_public_cidrs_access_enabled = true

    secondary_range_names = {
      pods     = "pods"
      services = "services"
    }

    master_authorized_ranges = {
        internal-vms               = "10.0.0.0/8"
        from-psi-aschaffenburg-vpn = "195.185.73.12/32"
        from-psi-berlin-vpn        = "213.61.67.236/32"
        from-psi-poznan-vpn        = "77.65.27.243/32"
    }
  }

  private_cluster_config = {
    enable_private_endpoint = false
    master_global_access    = true
  }

  deletion_protection = false

  depends_on = [
    module.vpc
  ]
}

data "google_client_config" "main" {}

resource "kubernetes_secret_v1" "iap_oauth_credentials" {
  metadata {
    name      = "iap-oauth-secret"
    namespace = "default"
  }
  data = {
    client_id     = google_iap_client.iap_client.client_id
    client_secret = google_iap_client.iap_client.secret # Sensitive value
  }
  type = "Opaque"
}

resource "google_artifact_registry_repository" "docker" {
  location      = var.region
  repository_id = "repo-container"
  description   = "Container repository"
  format        = "DOCKER"
}

module "nat" {
  source         = "git@gitlab.com:psi-software-se/terraform/modules.git//net-cloudnat?ref=stable"
  name           = "nat"
  project_id     = var.project_id
  region         = var.region
  router_network = module.vpc.name
}
