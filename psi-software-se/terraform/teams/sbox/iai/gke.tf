## Kubernetes cluster

# Service Accounts
data "google_service_account" "kubernetes" {
  project    = var.gcp_project_id
  account_id = "kubernetes-1"
}

module "gke-1" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-cluster-autopilot?ref=stable"
  project_id = var.gcp_project_id
  name       = "gke-1"
  location   = var.gcp_region
  vpc_config = {
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
    secondary_range_names = {
      pods     = "pods"
      services = "services"
    }
  }
  private_cluster_config = {
    enable_private_endpoint = false
    master_global_access    = true
  }
  labels = {
    environment = "sandbox"
  }
  node_config = {
    service_account = data.google_service_account.kubernetes.email
    tags            = [local.swp_internet_access_tag]
  }
  deletion_protection = false
  depends_on          = [module.vpc]
}
