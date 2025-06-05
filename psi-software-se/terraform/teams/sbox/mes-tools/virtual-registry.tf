module "registry-maven-releases-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-releases-group"
  format = {
    maven = {
      virtual = {
        maven-releases = {
          repository = module.registry-maven-dmf-releases-group.id
          priority   = 1
        }
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
module "registry-maven-thirdparty-releases-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-thirdparty-releases-group"
  format = {
    maven = {
      virtual = {
        maven-releases = {
          repository = module.registry-maven-central-proxy.id
          priority   = 1
        }
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
module "registry-maven-dmf-releases-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-dmf-releases-group"
  format = {
    maven = {
      virtual = {
        maven-releases = {
          repository = module.registry-maven-releases.id
          priority   = 1
        }
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
module "registry-maven-public-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-public"
  format = {
    maven = {
      virtual = {
        maven-releases-group = {
          repository = module.registry-maven-releases-group.id
          priority   = 1
        }
        maven-snapshots-group = {
          repository = module.registry-maven-snapshots-group.id
          priority   = 2
        }
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
module "registry-maven-snapshots-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-snapshots-group"
  format = {
    maven = {
      virtual = {
        maven-snapshots = {
          repository = module.registry-maven-snapshots.id
          priority   = 1
        }
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
module "registry-maven-dmf-snapshots-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-dmf-snapshots-group"
  format = {
    maven = {
      virtual = {
        maven-snapshots = {
          repository = module.registry-maven-snapshots.id
          priority   = 1
        }
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
module "registry-npm-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "npm-group"
  format = {
    npm = {
      virtual = {
        npm-dmf = {
          repository = module.registry-npm-dmf.id
          priority   = 1
        }
      }
    }
  }
}
module "registry-npm-thirdparty-group" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "npm-thirdparty-group"
  format = {
    npm = {
      virtual = {
        npm-dmf = {
          repository = module.registry-npm-org-proxy.id
          priority   = 1
        }
      }
    }
  }
}