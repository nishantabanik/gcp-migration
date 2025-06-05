resource "kubernetes_namespace" "sealed-secrets-ns" {
  metadata {
    name = "sealed-secrets"
  }
}

data "google_secret_manager_secret_version" "sealed_secrets_key" {
  secret  = "sealed-secrets-key"
  version = "latest"
}

data "google_secret_manager_secret_version" "sealed_secrets_crt" {
  secret  = "sealed-secrets-crt"
  version = "latest"
}


resource "kubernetes_secret_v1" "sealed-secrets-key" {
  depends_on = [kubernetes_namespace.sealed-secrets-ns]
  metadata {
    name      = "sealed-secrets-key"
    namespace = "sealed-secrets"
  }
  data = {
    "tls.crt" = data.google_secret_manager_secret_version.sealed_secrets_crt.secret_data
    "tls.key" = data.google_secret_manager_secret_version.sealed_secrets_key.secret_data
  }
  type = "kubernetes.io/tls"
}