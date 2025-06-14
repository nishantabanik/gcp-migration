/**
 * Copyright 2023-2024 Slalom GmbH
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description Automation project and resources.

module "automation-project" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//project?ref=stable"
  billing_account = var.billing_account.id
  name            = "iac-core-0"
  parent = coalesce(
    var.project_parent_ids.automation, "organizations/${var.organization.id}"
  )
  prefix = local.prefix
  # human (groups) IAM bindings
  # group_iam = {
  # }
  # machine (service accounts) IAM bindings
  iam = {
    "roles/owner" = [
      module.automation-tf-bootstrap-sa.iam_email
    ]
    "roles/cloudbuild.builds.editor" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/iam.serviceAccountAdmin" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/iam.workloadIdentityPoolAdmin" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/source.admin" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/storage.admin" = [
      module.automation-tf-resman-sa.iam_email
    ]
  }
  services = [
    "accesscontextmanager.googleapis.com",
    "bigquery.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "billingbudgets.googleapis.com",
    # Slalom: Cloud Asset API
    "cloudasset.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    # Slalom: Cloud Identity for gcloud identity groups create...
    "cloudidentity.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "essentialcontacts.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "orgpolicy.googleapis.com",
    "pubsub.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    # Slalom: (Deprecated) Cloud Source Repositories isn't available to new customers.
    # "sourcerepo.googleapis.com",
    "stackdriver.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "sts.googleapis.com"
  ]
}

# output files bucket

module "automation-tf-output-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  project_id    = module.automation-project.project_id
  name          = "iac-core-outputs-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  depends_on    = [module.organization]
}

# Slalom: Cloud Storage bucket to store build logs
module "build-log-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  project_id    = module.automation-project.project_id
  name          = "build-logs-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  lifecycle_rules = {
    lr-0 = {
      action = {
        type = "Delete"
      }
      condition = {
        age = 30
      }
    }
  }
  depends_on = [module.organization]
}

# this stage's bucket and service account

module "automation-tf-bootstrap-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  project_id    = module.automation-project.project_id
  name          = "iac-core-bootstrap-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  depends_on    = [module.organization]
}

module "automation-tf-bootstrap-sa" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  project_id   = module.automation-project.project_id
  name         = "bootstrap-0"
  display_name = "Terraform organization bootstrap service account."
  prefix       = local.prefix
  # allow SA used by CI/CD workflow to impersonate this SA
  iam = {
    "roles/iam.serviceAccountTokenCreator" = compact([
      try(module.automation-tf-cicd-sa["bootstrap"].iam_email, null)
    ])
  }
  iam_storage_roles = {
    (module.automation-tf-output-gcs.name) = ["roles/storage.admin"]
  }
}

# resource hierarchy stage's bucket and service account

module "automation-tf-resman-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  project_id    = module.automation-project.project_id
  name          = "iac-core-resman-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.automation-tf-resman-sa.iam_email]
  }
  depends_on = [module.organization]
}

module "automation-tf-resman-sa" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  project_id   = module.automation-project.project_id
  name         = "resman-0"
  display_name = "Terraform stage 1 resman service account."
  prefix       = local.prefix
  # allow SA used by CI/CD workflow to impersonate this SA
  # we use additive IAM to allow tenant CI/CD SAs to impersonate it
  iam_additive = {
    "roles/iam.serviceAccountTokenCreator" = compact([
      try(module.automation-tf-cicd-sa["resman"].iam_email, null)
    ])
  }
  iam_storage_roles = {
    (module.automation-tf-output-gcs.name) = ["roles/storage.admin"]
  }
}
