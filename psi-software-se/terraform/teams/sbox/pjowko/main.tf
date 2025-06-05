# created by project factory
data "google_service_account" "kubernetes" {
  project    = var.gcp_project_id
  account_id = "kubernetes-1"
}
