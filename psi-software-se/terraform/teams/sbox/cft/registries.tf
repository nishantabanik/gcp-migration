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
      "serviceAccount:${data.google_service_account.cloud_deploy.email}",
      "serviceAccount:${data.google_service_account.cloud_run.email}",
    ]
    "roles/artifactregistry.writer" = [
      "serviceAccount:${data.google_service_account.apps_sa.email}",
      "serviceAccount:${data.google_service_account.cloud_build.email}",
    ]
    "roles/artifactregistry.repoAdmin" = [
      "group:app-gcp-cft@psi.de",
    ]
  }
}

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
      "serviceAccount:${data.google_service_account.cloud_build.email}",
      "serviceAccount:${data.google_service_account.apps_sa.email}",
    ]
    "roles/artifactregistry.repoAdmin" = [
      "group:app-gcp-cft@psi.de",
    ]
  }
}

module "registry-maven-third-party" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-thirdparty"
  format = {
    maven = {
      standard = {
        version_policy = "RELEASE"
      }
    }
  }
  iam = {
    "roles/artifactregistry.repoAdmin" = [
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
    "roles/artifactregistry.writer" = [
      "serviceAccount:${data.google_service_account.cloud_build.email}",
      "serviceAccount:${data.google_service_account.apps_sa.email}",
    ]
    "roles/artifactregistry.repoAdmin" = [
      "group:app-gcp-cft@psi.de",
      "serviceAccount:${data.google_service_account.apps_sa.email}",
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
        maven-thirdparty = {
          repository = module.registry-maven-third-party.id
          priority   = 10
        }
      }
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "domain:psi.de",
    ]
  }
}

module "registry-maven-group-all" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-group-all"
  format = {
    maven = {
      virtual = {
        maven-releases = {
          repository = module.registry-maven-releases.id
          priority   = 1
        }
        maven-thirdparty = {
          repository = module.registry-maven-third-party.id
          priority   = 5
        }
        maven-snapshost = {
          repository = module.registry-maven-snapshots.id
          priority   = 10
        }
      }
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "group:app-gcp-cft@psi.de",
      "serviceAccount:${data.google_service_account.cloud_build.email}",
      "serviceAccount:${data.google_service_account.apps_sa.email}",
    ]
  }
}

module "registry-npm" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "npm"
  format = {
    npm = {
      standard = true
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "domain:psi.de",
    ]
    "roles/artifactregistry.writer" = [
      "serviceAccount:${data.google_service_account.cloud_build.email}",
      "serviceAccount:${data.google_service_account.apps_sa.email}",
    ]
    "roles/artifactregistry.repoAdmin" = [
      "group:app-gcp-cft@psi.de",
    ]
  }
}

module "registry-npm-npmjs-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "npm-npmjs-proxy"
  format = {
    npm = {
      remote = {
        public_repository = "NPMJS"
      }
    }
  }
}

module "registry-npm-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "npm-group"
  format = {
    npm = {
      virtual = {
        npmjs-proxy = {
          repository = module.registry-npm-npmjs-proxy.id
          priority   = 1
        }
        npm = {
          repository = module.registry-npm.id
          priority   = 10
        }
      }
    }
  }
  iam = {
    "roles/artifactregistry.reader" = [
      "group:app-gcp-cft@psi.de",
      "serviceAccount:${data.google_service_account.cloud_build.email}",
      "serviceAccount:${data.google_service_account.apps_sa.email}",
    ]
  }
}