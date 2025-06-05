module "registry-maven-releases" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id # e.g: "psi-de-0-example-1"
  location   = var.gcp_region # either "europe-west3" or "europe-west4"
  name       = "maven-releases"
  format = {
    maven = {
      standard = {
        version_policy = "RELEASE"
      }
    }
  }
  iam = {
    "roles/artifactregistry.writer" = ["group:app-gcp-sbox-xref-admins@psi.de"] # e.g.: ["serviceAccount:cloud-build-1@psi-de-0-example-1.iam.gserviceaccount.com"]
  }
}

module "registry-maven-snapshots" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id # e.g: "psi-de-0-example-1"
  location   = var.gcp_region # either "europe-west3" or "europe-west4"
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
    "roles/artifactregistry.writer" = ["group:app-gcp-sbox-xref-admins@psi.de"] # e.g.: ["serviceAccount:cloud-build-1@psi-de-0-example-1.iam.gserviceaccount.com"]
  }
}

module "registry-maven-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id # e.g: "psi-de-0-example-1"
  location   = var.gcp_region # either "europe-west3" or "europe-west4"
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
    "roles/artifactregistry.reader" = ["group:app-gcp-sbox-xref-admins@psi.de"] # e.g.: ["group:my-team@psi.de"]
  }
}