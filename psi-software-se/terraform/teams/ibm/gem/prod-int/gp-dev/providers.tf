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
    bucket = "psi-de-0-ibm-gp-dev-state"
  }
}

provider "google" {
  project                     = var.gcp_project_id
  region                      = var.gcp_region
  impersonate_service_account = var.enable_impersonate_sa ? "sa-ibm-gp-dev-0@psi-de-0-ibm-gp-dev.iam.gserviceaccount.com" : null
}

provider "google-beta" {
  project                     = var.gcp_project_id
  region                      = var.gcp_region
  impersonate_service_account = var.enable_impersonate_sa ? "sa-ibm-gp-dev-0@psi-de-0-ibm-gp-dev.iam.gserviceaccount.com" : null
}
