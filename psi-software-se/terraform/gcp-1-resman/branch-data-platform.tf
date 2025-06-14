/**
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

# tfdoc:file:description Data Platform stages resources.

module "branch-dp-folder" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  count  = var.fast_features.data_platform ? 1 : 0
  parent = "organizations/${var.organization.id}"
  name   = "Data Platform"
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/data"].id, null
    )
  }
}

module "branch-dp-dev-folder" {
  source    = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  count     = var.fast_features.data_platform ? 1 : 0
  parent    = module.branch-dp-folder[0].id
  name      = "Development"
  group_iam = {}
  iam = {
    (local.custom_roles.service_project_network_admin) = [
      module.branch-dp-dev-sa[0].iam_email
    ]
    # remove owner here and at project level if SA does not manage project resources
    "roles/owner"                          = [module.branch-dp-dev-sa[0].iam_email]
    "roles/logging.admin"                  = [module.branch-dp-dev-sa[0].iam_email]
    "roles/resourcemanager.folderAdmin"    = [module.branch-dp-dev-sa[0].iam_email]
    "roles/resourcemanager.projectCreator" = [module.branch-dp-dev-sa[0].iam_email]
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.environment}/development"].id,
      null
    )
  }
}

module "branch-dp-prod-folder" {
  source    = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  count     = var.fast_features.data_platform ? 1 : 0
  parent    = module.branch-dp-folder[0].id
  name      = "Production"
  group_iam = {}
  iam = {
    (local.custom_roles.service_project_network_admin) = [module.branch-dp-prod-sa[0].iam_email]
    # remove owner here and at project level if SA does not manage project resources
    "roles/owner"                          = [module.branch-dp-prod-sa[0].iam_email]
    "roles/logging.admin"                  = [module.branch-dp-prod-sa[0].iam_email]
    "roles/resourcemanager.folderAdmin"    = [module.branch-dp-prod-sa[0].iam_email]
    "roles/resourcemanager.projectCreator" = [module.branch-dp-prod-sa[0].iam_email]
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.environment}/production"].id,
      null
    )
  }
}

# automation service accounts and buckets

module "branch-dp-dev-sa" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  count        = var.fast_features.data_platform ? 1 : 0
  project_id   = var.automation.project_id
  name         = "dev-resman-dp-0"
  display_name = "Terraform data platform development service account."
  prefix       = var.prefix
  iam = {
    "roles/iam.serviceAccountTokenCreator" = compact([
      try(module.branch-dp-dev-sa-cicd[0].iam_email, null)
    ])
  }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectAdmin"]
  }
}

module "branch-dp-prod-sa" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  count        = var.fast_features.data_platform ? 1 : 0
  project_id   = var.automation.project_id
  name         = "prod-resman-dp-0"
  display_name = "Terraform data platform production service account."
  prefix       = var.prefix
  iam = {
    "roles/iam.serviceAccountTokenCreator" = compact([
      try(module.branch-dp-prod-sa-cicd[0].iam_email, null)
    ])
  }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectAdmin"]
  }
}

module "branch-dp-dev-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  count         = var.fast_features.data_platform ? 1 : 0
  project_id    = var.automation.project_id
  name          = "dev-resman-dp-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.branch-dp-dev-sa[0].iam_email]
  }
}

module "branch-dp-prod-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  count         = var.fast_features.data_platform ? 1 : 0
  project_id    = var.automation.project_id
  name          = "prod-resman-dp-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.branch-dp-prod-sa[0].iam_email]
  }
}

resource "google_organization_iam_member" "org_policy_admin_dp" {
  for_each = !var.fast_features.data_platform ? {} : {
    data-dev  = ["data", "development", module.branch-dp-dev-sa[0].iam_email]
    data-prod = ["data", "production", module.branch-dp-prod-sa[0].iam_email]
  }
  org_id = var.organization.id
  role   = "roles/orgpolicy.policyAdmin"
  member = each.value[2]
  condition {
    title       = "org_policy_tag_dp_scoped"
    description = "Org policy tag scoped grant for ${each.value[0]}/${each.value[1]}."
    expression  = <<-END
    resource.matchTag('${var.organization.id}/${var.tag_names.context}', '${each.value[0]}')
    &&
    resource.matchTag('${var.organization.id}/${var.tag_names.environment}', '${each.value[1]}')
    END
  }
}
