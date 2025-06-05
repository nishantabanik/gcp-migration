data "google_project" "self" {
  project_id = var.project_id
}

data "google_service_account" "crossplane" {
  account_id = "crossplane"
}

resource "google_service_account_iam_binding" "crossplane" {
  service_account_id = data.google_service_account.crossplane.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${data.google_project.self.project_id}.svc.id.goog[idp/crossplane]"
  ]
}

# region CLEANUP dc2dc088-26a7-4026-bf47-b7bcadd89bdf
# This IAM binding will eventually be created by project factory. Then, the following section can be removed.
data "google_service_account" "gitlab" {
  account_id = "gitlab-ci-1"
}

resource "google_service_account_iam_binding" "wif-binding" {
  service_account_id = data.google_service_account.gitlab.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    format(
      "principalSet://iam.googleapis.com/projects/${var.psi_project_id}/locations/global/workloadIdentityPools/${var.workload_identity_pool}/attribute.repository/%s",
      "psi-software-se/terraform/teams/wms"
    )
  ]
}
# endregion CLEANUP dc2dc088-26a7-4026-bf47-b7bcadd89bdf

resource "google_artifact_registry_repository" "docker" {
  location      = var.region
  repository_id = "repo-container"
  description   = "Container repository"
  format        = "DOCKER"
}

resource "google_project_iam_binding" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"

  members = [
    "serviceAccount:932805510891-compute@developer.gserviceaccount.com",
  ]
}

resource "helm_release" "idp" {
  chart             = "../platform"
  name              = "idp"
  namespace         = "idp"
  create_namespace  = true
  dependency_update = true
  upgrade_install   = true
  reset_values      = true

  values = [
    file("${path.module}/../platform/values.yaml")
  ]

  set {
    name  = "chart-hash"
    value = sha1(join("", [for f in fileset("${path.module}/../platform", "**/*.yaml") : filesha1("${path.module}/../platform/${f}")]))
  }

  depends_on = [helm_release.argocd]
}

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


resource "kubernetes_secret" "sealed-secrets-key" {
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

resource "helm_release" "sealed_secrets" {
  depends_on = [kubernetes_secret.sealed-secrets-key]
  name       = "sealed-secrets"
  namespace  = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.16.1"
}

resource "kubernetes_manifest" "argocd_secrets" {
  for_each = fileset("${path.module}/argocd/secrets", "*.yaml")
  manifest = yamldecode(file("${path.module}/argocd/secrets/${each.value}"))

  depends_on = [helm_release.sealed_secrets]
}

