module "cluster-1" {
  source              = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-cluster-standard?ref=stable"
  count               = var.gke_standard_enabled ? 1 : 0
  project_id          = var.gcp_project_id
  name                = "cluster-1"
  location            = var.gcp_zone
  deletion_protection = false
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
  }
  depends_on = [
    module.vpc.self_link
  ]
}

module "nodepool-1" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-nodepool?ref=stable"
  count        = var.gke_standard_enabled ? 1 : 0
  project_id   = var.gcp_project_id
  cluster_name = module.cluster-1[0].name
  location     = var.gcp_zone
  name         = "nodepool-1"
  node_config = {
    machine_type        = "n2-standard-2"
    disk_size_gb        = 50
    disk_type           = "pd-ssd"
    ephemeral_ssd_count = 1
    gvnic               = true
    spot                = true
  }
  service_account = {
    email = data.google_service_account.kubernetes.email
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
  depends_on = [
    module.cluster-1[0].self_link
  ]
}
