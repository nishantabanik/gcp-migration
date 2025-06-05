/**
 * Copyright 2025 Slalom GmbH
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

moved {
  from = module.branch-ibm-folder
  to   = module.branch-legacy-folder
}

module "branch-legacy-folder" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  parent = "organizations/${var.organization.id}"
  name   = "Legacy"
  # TODO: Check Group name (sbox is in the name) IAM !!!
  group_iam = {
    "app-gcp-sbox-its-admins@psi.de" = [
      "roles/dns.admin",
      "roles/compute.securityAdmin",
      "roles/logging.admin",
      "roles/owner", # TODO: Remove after check!
      "roles/resourcemanager.folderAdmin",
      "roles/bigquery.admin",
      "roles/cloudasset.owner",
      "roles/cloudkms.admin",
      "roles/secretmanager.admin",
      "roles/storage.admin",
    ]
  }
  iam = {
    (local.custom_roles.service_project_network_admin) = (
      local.branch_optional_sa_lists.pf-legacy
    )
    "roles/logging.admin"                  = local.branch_optional_sa_lists.pf-legacy
    "roles/owner"                          = local.branch_optional_sa_lists.pf-legacy
    "roles/resourcemanager.folderAdmin"    = local.branch_optional_sa_lists.pf-legacy
    "roles/resourcemanager.projectCreator" = local.branch_optional_sa_lists.pf-legacy
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/legacy"].id, null
    )
  }
}

# TODO: Delete after Terraform state is moved!
module "branch-ibm-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  project_id    = var.automation.project_id
  name          = "resman-ibm-state-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = local.branch_optional_sa_lists.pf-legacy
  }
}
