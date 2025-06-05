data "google_service_account" "gitlab-self-service-sa" {
  project    = var.gcp_project_id
  account_id = "gitlab-self-service-sa"
}

data "google_service_account" "kubernetes" {
  project    = var.gcp_project_id
  account_id = "kubernetes-1"
}
