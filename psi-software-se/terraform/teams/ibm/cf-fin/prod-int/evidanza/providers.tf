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
    bucket = "psi-de-0-ibm-cfo-evidanza-prd-state"
  }
}

provider "google" {
  project                     = var.gcp_project_id
  region                      = var.gcp_region
  impersonate_service_account = var.enable_impersonate_sa ? "sa-ibm-cfo-evidanza-prd-0@psi-de-0-ibm-cfo-evidanza-prd.iam.gserviceaccount.com" : null
}

provider "google-beta" {
  project                     = var.gcp_project_id
  region                      = var.gcp_region
  impersonate_service_account = var.enable_impersonate_sa ? "sa-ibm-cfo-evidanza-prd-0@psi-de-0-ibm-cfo-evidanza-prd.iam.gserviceaccount.com" : null
}
