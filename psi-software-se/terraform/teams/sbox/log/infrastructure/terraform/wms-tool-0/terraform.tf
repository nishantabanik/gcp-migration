terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.10"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.34.0"
    }

  }

  required_version = "~> 1.7"
}
