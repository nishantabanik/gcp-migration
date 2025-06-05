module "bucket" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  project_id = var.gcp_project_id
  storage_class = "STANDARD"
  location   = var.gcp_region
  name       = "artrepo"
  iam = {
    "roles/storage.objectUser" = [
      "group:app-gcp-sbox-csf-admins@psi.de",
      "serviceAccount:${data.google_service_account.gitlab-app-sa.email}",
    ]
    "roles/storage.objectViewer" = [
      "group:app-gcp-sbox-csf@psi.de"
    ]
  }
}