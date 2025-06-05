### Service Accounts

data "google_service_account" "compute" {
  project    = var.gcp_project_id
  account_id = "compute-1"
}

data "google_service_account" "kubernetes" {
  project    = var.gcp_project_id
  account_id = "kubernetes-1"
}