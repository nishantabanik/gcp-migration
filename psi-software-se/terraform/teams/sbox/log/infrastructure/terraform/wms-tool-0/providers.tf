provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "http" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
