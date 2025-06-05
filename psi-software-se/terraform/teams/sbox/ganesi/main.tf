# common datasources, locals, resources
# data "google_service_account" "gitlab-app-sa" {
#   project    = var.gcp_project_id
#   account_id = "gitlab-app-sa"
# }

locals {
  swp_internet_access_tag = "internet-via-swp"
}
