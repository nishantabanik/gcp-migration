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
# tfdoc:file:description (Deprecated) Create a Cloud Source repository for Terraform modules.

# Slalom: Separate Cloud Source repository for Terraform modules.
#         Please note: Google Cloud Source Repositories isn't available to new customers.
module "automation-tf-modules-repo" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//source-repository?ref=stable"
  count      = var.deprecated_sourcerepo ? 1 : 0
  project_id = module.automation-project.project_id
  name       = var.modules_repository.name
  iam_additive = {
    "roles/source.admin" = [module.automation-tf-bootstrap-sa.iam_email]
    "roles/source.reader" = compact([
      # Allow all useres in the organization to read modules.
      # This way users in the organization can use the modules in there own IaC.
      "domain:${var.organization.domain}",
      # Additionally, allow the service accounts to read the modules.
      try(module.automation-tf-cicd-sa["bootstrap"].iam_email, null),
      try(module.automation-tf-cicd-sa["resman"].iam_email, null)
    ])
  }
}