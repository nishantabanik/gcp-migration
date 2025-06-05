module "registry-docker" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region # either "europe-west3" or "europe-west4"
  name       = "container-images"
  format = {
    docker = {
      standard = {
        immutable_tags = false
      }
    }
  }
}