### Service Accounts

data "google_service_account" "apps_sa" {
  project    = var.gcp_project_id
  account_id = "apps-sa"
}
data "google_service_account" "kubernetes" {
  project    = var.gcp_project_id
  account_id = "kubernetes-1"
}
