module "gke-cluster-standard" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-cluster-standard?ref=stable"
  project_id = var.gcp_project_id
  name       = var.gcp_cluster_name
  location   = var.gcp_region
  vpc_config = {
    network    = var.gcp_network # For shared VPC: "projects/psi-de-0-dev-net-spoke-0/global/networks/dev-spoke-0" 
    subnetwork = var.gcp_subnetwork # For shared VPC: "projects/psi-de-0-dev-net-spoke-0/regions/europe-west3/subnetworks/dev-gke-nodes-ew3"
    secondary_range_names = {
      pods     = "pods"
      services = "services"
    }
    master_authorized_ranges = {
      internal-vms = "10.0.0.0/8"
      from-psi = "77.65.27.0/24" # e.g.: "77.65.27.0/24"
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
    service_account = data.google_service_account.kubernetes.email # e.g.: "kubernetes-1@psi-de-0-example-1.iam.gserviceaccount.com", can be created in project factory
  }
  enable_addons = {
	  gce_persistent_disk_csi_driver = true
  }
  deletion_protection = false
  depends_on = [
    module.vpc.self_link # Put VPC module name here to create cluster when VPC will be available
  ]
}

module "gke-nodepool" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-nodepool?ref=stable"
  project_id   = var.gcp_project_id # e.g: "psi-de-0-example-1"
  cluster_name = var.gcp_cluster_name # e.g.: "example-1"
  location     = var.gcp_region # either "europe-west3" or "europe-west4", same as for cluster
  name         = var.gpc_nodepool_name
  node_config = {
    machine_type        = "n2-standard-2" # for example "n2-standard-2"
    disk_size_gb        = 50
    disk_type           = "pd-ssd"
    ephemeral_ssd_count = 1
    gvnic               = true
    spot                = true
  }
  service_account = {
    email = data.google_service_account.kubernetes.email # e.g.: "kubernetes-1@psi-de-0-example-1.iam.gserviceaccount.com", can be created in project factory
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
    module.gke-cluster-standard.self_link
  ]
}