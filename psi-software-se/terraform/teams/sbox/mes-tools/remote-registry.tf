module "registry-maven-central-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "maven-central"
  format = {
    maven = {
      remote = {
        public_repository = "MAVEN_CENTRAL"
      }
    }
  }
}
module "registry-npm-org-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "npm-org"
  format = {
    npm = {
      remote = {
        public_repository = "NPMJS"
      }
    }
  }
}

module "registry-pypi-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "pypi-proxy"
  format = {
    python = {
      remote = {
        public_repository = "PYPI"
      }
    }
  }
}

module "registry-docker-proxy-gcr-io-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "docker-proxy-gcr-io"
  format = {
    docker = {
      remote = {
        custom_repository = "https://gcr.io"
      }
    }
  }
}
module "registry-docker-proxy-ghcr-io-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "docker-proxy-ghcr-io"
  format = {
    docker = {
      remote = {
        custom_repository = "https://ghcr.io"
      }
    }
  }
}
module "registry-docker-proxy-container-registry-oracle-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "docker-proxy-container-registry-oracle-com"
  format = {
    docker = {
      remote = {
        custom_repository = "https://container-registry.oracle.com"
      }
    }
  }
}
module "registry-docker-proxy-mcr-microsoft-com-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "docker-proxy-mcr-microsoft-com"
  format = {
    docker = {
      remote = {
        custom_repository = "https://mcr.microsoft.com"
      }
    }
  }
}
module "registry-docker-proxy-docker-io-proxy" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "docker-proxy-docker-io"
  format = {
    docker = {
      remote = {
        custom_repository = "https://registry-1.docker.io"
      }
    }
  }
}
