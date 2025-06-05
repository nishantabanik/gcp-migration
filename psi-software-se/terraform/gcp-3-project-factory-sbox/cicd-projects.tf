locals {
  bucket_location = "europe-west3"
  bucket_class    = "STANDARD"
  gitlabs         = {for k, v in local.projects : k => module.projects[k] if v.cicd != null}
}

module "project_sa" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  for_each     = local.gitlabs
  project_id   = each.value.project_id
  prefix       = var.prefix
  name         = "sb-${each.key}-0"
  display_name = "Terraform sandbox project ${each.key} service account."
  iam = {
    "roles/iam.serviceAccountTokenCreator" = compact([
      try(module.project_sa_cicd[each.key].iam_email, null)
    ])
  }
  iam_project_roles = {
    (each.value.project_id) = try(local.projects[each.key].cicd.sa_roles, ["roles/editor"])
  }
}

module "project_sa_cicd" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  for_each     = local.gitlabs
  project_id   = each.value.project_id
  name         = "sb-${each.key}-1"
  display_name = "Terraform CI/CD project ${each.key} service account."
  prefix       = var.prefix
  iam = {
    "roles/iam.workloadIdentityUser" = [
      format(
        "principalSet://iam.googleapis.com/%s/attribute.repository/%s",
        var.automation.federated_identity_pool,
        local.projects[each.key].cicd.repository
      )
    ]
  }
}

module "project_gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  for_each      = local.gitlabs
  project_id    = each.value.project_id
  name          = "sb-${each.key}-state"
  prefix        = var.prefix
  location      = local.bucket_location
  storage_class = local.bucket_class
  force_destroy = true
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.project_sa[each.key].iam_email]
  }
}

output "cicd_for_projects" {
  value = {
    for k, v in local.gitlabs : k => {
      state_bucket = module.project_gcs[k].id
      gitlab_sa    = module.project_sa_cicd[k].email
      gcp_sa       = module.project_sa[k].email
    }
  }
}