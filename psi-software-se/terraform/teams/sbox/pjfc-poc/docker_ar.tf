module "registry-docker" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id 
  location   = var.gcp_region
  name       = "container-images-docker-ar"
  format = {
    docker = {
      standard = {
        immutable_tags = false
      }
    }
  }
  iam = {
    "roles/artifactregistry.writer" = [
      "group:app-gcp-sbox-pjfc-poc-admins@psi.de",
      "serviceAccount:${data.google_service_account.apps_sa.email}"
    ]
    "roles/artifactregistry.reader" = [
      "group:app-gcp-sbox-pjfc-poc@psi.de",
      "serviceAccount:${data.google_service_account.kubernetes.email}",
    ]
  }
}