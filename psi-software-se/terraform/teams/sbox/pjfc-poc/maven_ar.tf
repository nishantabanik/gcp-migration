module "registry-maven-releases" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id 
  location   = var.gcp_region
  name       = "maven-releases"
  format = {
    maven = {
      standard = {
        version_policy = "RELEASE"
      }
    }
  }
  iam = {
    "roles/artifactregistry.writer" = [
      "group:app-gcp-sbox-pjfc-poc-admins@psi.de"
    ]
    "roles/artifactregistry.reader" = [
      "group:app-gcp-sbox-pjfc-poc@psi.de"
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
        version_policy = "SNAPSHOT"
        allow_snapshot_overwrites = true
      }
    }
  }
  iam = {
    "roles/artifactregistry.writer" = [
      "group:app-gcp-sbox-pjfc-poc-admins@psi.de"
    ]
    "roles/artifactregistry.reader" = [
      "group:app-gcp-sbox-pjfc-poc@psi.de"
    ]
  }
}

module "registry-maven-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id 
  location   = var.gcp_region
  name       = "maven-group"
  format = {
    maven = {
      virtual = {
        maven-releases = {
          repository = module.registry-maven-releases.id
          priority   = 1
        }
        maven-snapshots = {
          repository = module.registry-maven-snapshots.id
          priority   = 10
        }
      }
    }
  }
  iam = {
    "roles/artifactregistry.writer" = [
      "group:app-gcp-sbox-pjfc-poc-admins@psi.de"
    ]
    "roles/artifactregistry.reader" = [
      "group:app-gcp-sbox-pjfc-poc@psi.de"
    ]
  }
}