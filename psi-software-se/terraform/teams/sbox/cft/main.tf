locals {
  swp_internet_access_tag = "internet-via-swp"
}


### Service Accounts

data "google_service_account" "apps_sa" {
  project    = var.gcp_project_id
  account_id = "apps-sa"
}

data "google_service_account" "compute" {
  project    = var.gcp_project_id
  account_id = "compute-1"
}

data "google_service_account" "kubernetes" {
  project    = var.gcp_project_id
  account_id = "kubernetes-1"
}

data "google_service_account" "cloud_build" {
  project    = var.gcp_project_id
  account_id = "cloud-build-1"
}

data "google_service_account" "cloud_run" {
  project    = var.gcp_project_id
  account_id = "cloud-run-1"
}

data "google_service_account" "cloud_deploy" {
  project    = var.gcp_project_id
  account_id = "cloud-deploy-1"
}
