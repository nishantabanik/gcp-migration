# common datasources, locals, resources
data "google_service_account" "gitlab-app-sa" {
  project    = var.gcp_project_id
  account_id = "gitlab-app-sa"
}

data "google_project" "project" {
  project_id = var.gcp_project_id
}

locals {
  swp_internet_access_tag = "internet-via-swp"
}
