data "google_service_account" "apps_sa" {
  project    = var.gcp_project_id
  account_id = "apps-sa"
}

module "registry-container-images" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "container-images"
  format = {
    docker = {
      standard = {
        immutable_tags = false
      }
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "domain:psi.de",
      "serviceAccount:${data.google_service_account.kubernetes.email}",
    ]
    "roles/artifactregistry.writer" = [
      "serviceAccount:${data.google_service_account.apps_sa.email}",
      "group:app-gcp-cft@psi.de",
    ]
  }
}

module "registry-maven-snapshots" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-snapshots"
  format = {
    maven = {
      standard = {
        version_policy            = "SNAPSHOT"
        allow_snapshot_overwrites = true
      }
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "domain:psi.de",
      "serviceAccount:${data.google_service_account.kubernetes.email}"
    ]
    "roles/artifactregistry.writer" = [
      "serviceAccount:${data.google_service_account.apps_sa.email}"
    ]
    "roles/artifactregistry.repoAdmin" = [
      "group:app-gcp-cft@psi.de"
    ]
  }
}