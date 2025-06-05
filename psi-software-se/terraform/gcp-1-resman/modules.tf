/**
 * Copyright 2023-2024 Slalom GmbH
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
# tfdoc:file:description (Deprecated) Add all CI/CD service accounts as reader to Cloud Source repository for Terraform modules.

locals {
  deprecated_sourcerepo = var.automation.module_repository == "SOURCEREPO_CICD_MODULE_REPOSITORY_NAME_DISABLED" ? false : true
  branch_cicd_sa_lists = compact([
    try(module.branch-dp-dev-sa-cicd[0].iam_email, null),
    try(module.branch-dp-prod-sa-cicd[0].iam_email, null),
    try(module.branch-gke-dev-sa-cicd[0].iam_email, null),
    try(module.branch-gke-prod-sa-cicd[0].iam_email, null),
    try(module.branch-network-sa-cicd[0].iam_email, null),
    try(module.branch-pf-dev-sa-cicd[0].iam_email, null),
    try(module.branch-pf-dev-sa[0].iam_email, null),
    try(module.branch-pf-prod-sa-cicd[0].iam_email, null),
    try(module.branch-pf-prod-sa[0].iam_email, null),
    try(module.branch-pf-sbox-sa-cicd[0].iam_email, null),
    try(module.branch-pf-sbox-sa[0].iam_email, null),
    try(module.branch-security-sa-cicd[0].iam_email, null)
  ])
}

# Slalom: Separate Cloud Source repository for Terraform modules.
#         Please note: Google Cloud Source Repositories isn't available to new customers.
resource "google_sourcerepo_repository_iam_member" "cloud-source-modules-cicd-sa-users" {
  for_each   = local.deprecated_sourcerepo ? toset(local.branch_cicd_sa_lists) : []
  project    = var.automation.project_id
  repository = var.automation.module_repository
  role       = "roles/source.reader"
  member     = each.key
}
