module "registry-docker" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//artifact-registry?ref=stable"
  project_id = var.gcp_project_id
  location   = var.gcp_region
  name       = "artifacts"
  format = {
    docker = {
      standard = {
        immutable_tags = false
      }
    }
  }
  iam = {
    "roles/artifactregistry.repoAdmin" = [
      "serviceAccount:${data.google_service_account.gitlab-app-sa.email}",
      "group:app-gcp-sbox-csf-admins@psi.de",
      "group:app-gcp-sbox-csf@psi.de"
    ]
    "roles/artifactregistry.reader" = [
      "serviceAccount:${data.google_service_account.kubernetes.email}",

      # Grant read permission to ArgoCD Image Updater service account in GKE
      # see https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to
      "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.gcp_project_id}.svc.id.goog/subject/ns/argocd-image-updater/sa/argocd-image-updater"
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
      "serviceAccount:${data.google_service_account.gitlab-app-sa.email}",
      "group:app-gcp-sbox-csf-admins@psi.de"
    ]
    "roles/artifactregistry.reader" = [
      "serviceAccount:${data.google_service_account.kubernetes.email}",
      "group:app-gcp-sbox-csf@psi.de"
    ]
  }
}
