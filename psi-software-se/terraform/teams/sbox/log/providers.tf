terraform {
  required_version = ">= 1.4.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
  backend "gcs" {
    bucket = "psi-de-0-sb-sandbox-log-state"
  }
}
provider "google" {
  project = var.project_id
  region  = var.region
  impersonate_service_account = var.impersonate_service_account
}
provider "google-beta" {
  project = var.project_id
  region  = var.region
  impersonate_service_account = var.impersonate_service_account
}

provider "kubernetes" {
  host  = "https://${module.gke-cluster-main.cluster.endpoint}"
  token = data.google_client_config.main.access_token
  cluster_ca_certificate = base64decode(module.gke-cluster-main.cluster.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}
