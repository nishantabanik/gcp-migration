module "registry-helm" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "helm"
  format     = {
    docker = {
      standard = {
        immutable_tags = false
      }
    }
  }
}
module "registry-docker" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "docker"
  format     = {
    docker = {
      standard = {
        immutable_tags = false
      }
    }
    iam = {
      "roles/artifactregistry.reader" = [
        "domain:psi.de",
        "serviceAccount:${data.google_service_account.kubernetes.email}",
      ]
      "roles/artifactregistry.writer" = [
        "serviceAccount:${data.google_service_account.gitlab-self-service-sa.email}",
        "group:app-gcp-sbox-mes-admins@psi.de",
      ]
      "roles/artifactregistry.repoAdmin" = [
        "group:app-gcp-sbox-mes-admins@psi.de",
      ]
    }
  }
}