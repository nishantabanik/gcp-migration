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
    bucket = "psi-de-0-sb-sandbox-ganesi-state"
  }
}

provider "google" {
  project                     = var.gcp_project_id
  region                      = var.gcp_region
  impersonate_service_account = var.enable_impersonate_sa ? "psi-de-0-sb-sandbox-ganesi-0@psi-de-0-sandbox-ganesi.iam.gserviceaccount.com" : null
}

provider "google-beta" {
  project                     = var.gcp_project_id
  region                      = var.gcp_region
  impersonate_service_account = var.enable_impersonate_sa ? "psi-de-0-sb-sandbox-ganesi-0@psi-de-0-sandbox-ganesi.iam.gserviceaccount.com" : null
}
