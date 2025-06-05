module "gke-cluster-standard" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-cluster-standard?ref=stable"
  project_id = var.gcp_project_id 
  name       = "mes-test-infrastructure"
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
    environment = "mes-tools-sandbox"
    owner       = "psi"
  }
  node_config = {
    service_account = data.google_service_account.kubernetes.email
    tags = [var.swp_internet_access_tag]
  }
  deletion_protection = false
  depends_on = [
    module.vpc.self_link
  ]
}
module "gke-nodepool" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-nodepool?ref=stable"
  project_id   = var.gcp_project_id
  cluster_name = "mes-test-infrastructure"
  location     = var.gcp_region
  name         = "mes-test-infrastructure-node-pool"
  node_config = {
    machine_type        = "n2-standard-2"
    disk_size_gb        = 50
    disk_type           = "pd-ssd"
    ephemeral_ssd_count = 1
    gvnic               = true
    spot                = false
  }
  service_account = {
    email = data.google_service_account.kubernetes.email
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  nodepool_config = {
    autoscaling = {
      max_node_count = 2
      min_node_count = 1
    }
    management = {
      auto_repair  = true
      auto_upgrade = true
    }
  }
  tags = [var.swp_internet_access_tag]
  node_count = {
    initial = 0
  }
  depends_on = [
    module.gke-cluster-standard.self_link
  ]
}

module "test-autopilot" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-cluster-autopilot?ref=stable"
  project_id = var.gcp_project_id
  name       = "test-autopilot"
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
    tags            = [var.swp_internet_access_tag]
  }
  deletion_protection = false
  depends_on          = [module.vpc]

}
