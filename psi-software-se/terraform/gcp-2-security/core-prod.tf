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

locals {
  prod_kms_restricted_admins = [
    for sa in compact([
      var.service_accounts.data-platform-prod,
      var.service_accounts.project-factory-prod
    ]) : "serviceAccount:${sa}"
  ]
}

module "prod-sec-project" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//project?ref=stable"
  name            = "prod-sec-core-${var.postfix}"
  parent          = var.folder_ids.security
  prefix          = var.prefix
  billing_account = var.billing_account.id
  iam = {
    "roles/cloudkms.viewer" = local.prod_kms_restricted_admins
  }
  labels   = { environment = "prod", team = "security" }
  services = local.project_services
}

module "prod-sec-kms" {
  for_each   = toset(local.kms_locations)
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//kms?ref=stable"
  project_id = module.prod-sec-project.project_id
  keyring = {
    location = each.key
    name     = "prod-${each.key}"
  }
  # rename to `key_iam` to switch to authoritative bindings
  key_iam_additive = {
    for k, v in local.kms_locations_keys[each.key] : k => v.iam
  }
  keys = local.kms_locations_keys[each.key]
}

# TODO(ludo): add support for conditions to Fabric modules

resource "google_project_iam_member" "prod_key_admin_delegated" {
  for_each = toset(local.prod_kms_restricted_admins)
  project  = module.prod-sec-project.project_id
  role     = "roles/cloudkms.admin"
  member   = each.key
  condition {
    title       = "kms_sa_delegated_grants"
    description = "Automation service account delegated grants."
    expression = format(
      "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly([%s]) && resource.type == 'cloudkms.googleapis.com/CryptoKey'",
      join(",", formatlist("'%s'", [
        "roles/cloudkms.cryptoKeyEncrypterDecrypter",
        "roles/cloudkms.cryptoKeyEncrypterDecrypterViaDelegation"
      ]))
    )
  }
  depends_on = [module.prod-sec-project]
}
