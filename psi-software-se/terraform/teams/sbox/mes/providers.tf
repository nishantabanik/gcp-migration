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
    bucket = "psi-de-0-sb-sbox-mes-state"
    impersonate_service_account = "psi-de-0-sb-sbox-mes-0@psi-de-0-sbox-mes.iam.gserviceaccount.com"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  impersonate_service_account = "psi-de-0-sb-sbox-mes-0@psi-de-0-sbox-mes.iam.gserviceaccount.com"
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region
  impersonate_service_account = "psi-de-0-sb-sbox-mes-0@psi-de-0-sbox-mes.iam.gserviceaccount.com"
}