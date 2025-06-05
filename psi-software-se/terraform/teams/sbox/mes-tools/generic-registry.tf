module "registry-deliverable-binaries" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "deliverable-binaries"
  format = {
    generic = {
      standard = true
    }
  }
}
module "registry-tool-binaries" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "tool-binaries"
  format = {
    generic = {
      standard = true
    }
  }
}
