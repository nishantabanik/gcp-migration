module "secret-manager" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//secret-manager?ref=stable"
  project_id = var.gcp_project_id
  secrets = {
    simple-secret-manager-database-password = {
      locations = [var.gcp_region]
    }
  }
  iam = {
    simple-secret-manager-database-password = {
      "roles/secretmanager.secretAccessor" = [
        "principalSet://iam.googleapis.com/projects/504787948326/locations/global/workloadIdentityPools/psi-de-0-bootstrap/attribute.project_id/69214431",
      ]
    }
  }
}