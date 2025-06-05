# tfdoc:file:description GitLab CI configuration per project.

locals {
  bucket_location = "europe-west3"
  bucket_class    = "STANDARD"
  gitlabs         = { for k, v in local.projects : k => module.projects[k] if v.cicd != null }
  _sa = {
    for k, v in local.projects : k => {
      "sa-${k}-0" : v.cicd.sa_roles
      "sa-${k}-1" : []
    } if try(v.cicd, null) != null
  }
  _sa_iam = {
    for k, v in local.projects : k => {
      "sa-${k}-0" : {
        "roles/iam.serviceAccountTokenCreator" : [
          "serviceAccount:sa-${k}-1@psi-de-0-${k}.iam.gserviceaccount.com"
        ]
      }
      "sa-${k}-1" : {
        "roles/iam.workloadIdentityUser" : [
          "principalSet://iam.googleapis.com/projects/504787948326/locations/global/workloadIdentityPools/psi-de-0-bootstrap/attribute.repository/${v.cicd.repository}"
        ]
      }
    } if try(v.cicd, null) != null
  }
}

module "project_gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  for_each      = local.gitlabs
  project_id    = each.value.project_id
  name          = "${each.key}-state"
  prefix        = var.prefix
  location      = local.bucket_location
  storage_class = local.bucket_class
  force_destroy = true
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = ["serviceAccount:sa-${each.key}-0@psi-de-0-${each.key}.iam.gserviceaccount.com"]
  }
}