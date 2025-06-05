module "registry-maven-releases" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-releases"
  format     = {
    maven = {
      standard = {
        version_policy = "RELEASE"
      }
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "domain:psi.de",
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

module "registry-maven-snapshots" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-snapshots"
  format     = {
    maven = {
      standard = {
        version_policy = "SNAPSHOT"
        allow_snapshot_overwrites = true
      }
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "domain:psi.de",
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

