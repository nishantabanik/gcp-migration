module "registry-npm-dmf" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "npm-dmf"
  format = {
    npm = {
      standard = true
    }
  }
}
