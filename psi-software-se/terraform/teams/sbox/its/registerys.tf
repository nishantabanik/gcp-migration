module "registry-docker" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id # e.g: "psi-de-0-example-1" 
  location   = var.gcp_region # either "europe-west3" or "europe-west4"
  name       = "container-images"
  format = {
    docker = {
      standard = {
        immutable_tags = false
      }
    }
  }
  iam = {
    "roles/artifactregistry.writer" = [
      "group:app-gcp-sbox-its-admins@psi.de"
    ]
    "roles/artifactregistry.reader" = [
      "group:app-gcp-sbox-its@psi.de"
    ]
  }
}