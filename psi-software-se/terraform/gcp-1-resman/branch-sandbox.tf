/**
 * Copyright 2023 Google LLC
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

# tfdoc:file:description Sandbox stage resources.

module "branch-sandbox-folder" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  count  = var.fast_features.sandbox ? 1 : 0
  parent = "organizations/${var.organization.id}"
  name   = "PreDev"
  iam = {
    "roles/logging.admin"                  = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
    "roles/owner"                          = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
    "roles/resourcemanager.folderAdmin"    = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
    "roles/resourcemanager.projectCreator" = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
  }
  org_policies = {
    "custom.restrictNatForSwpOnly" = {
      rules = [{ enforce = true }]
    }
  }

  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/sandbox"].id, null
    )
  }
  firewall_policies = {
    restrict-external = {
      allow-internal-ipv4-ingress = {
        description             = "Allow internal ingress traffic"
        direction               = "INGRESS"
        action                  = "goto_next" # Still it is up to project to decide what is allowed
        priority                = 900
        ranges                  = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"] # Private IP address ranges
        ports                   = { all = [] }
        target_service_accounts = null
        target_resources        = null
        logging                 = false
      }
      allow-internal-ipv4-egress = {
        description             = "Allow internal egress traffic"
        direction               = "EGRESS"
        action                  = "goto_next" # Still it is up to project to decide what is allowed
        priority                = 901
        ranges                  = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"] # Private IP address ranges
        ports                   = { all = [] }
        target_service_accounts = null
        target_resources        = null
        logging                 = false
      }
      allow-ipv4-iap = {
        description             = "Allow Identity-Aware Proxy access"
        direction               = "INGRESS"
        action                  = "goto_next"
        priority                = 910
        ranges                  = ["35.235.240.0/20"] # Google IAP proxy
        ports                   = { all = [] }
        target_service_accounts = null
        target_resources        = null
        logging                 = false
      }
      allow-google-api-ipv4-egress = {
        description             = "Allow Google API private access"
        direction               = "EGRESS"
        action                  = "goto_next" # Still it is up to project to decide what is allowed
        priority                = 930
        ranges                  = ["34.126.0.0/18", "199.36.153.4/30", "199.36.153.8/30"]
        ports                   = { tcp = ["443"] }
        target_service_accounts = null
        target_resources        = null
        logging                 = false
      }
      allow-gke-services-hc = {
        description             = "Allow GKE external services health-checks access"
        direction               = "INGRESS"
        action                  = "goto_next"
        priority                = 950
        ranges                  = ["130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"] # Health check probe source IP ranges
        ports                   = { tcp = ["80", "443", "1024-49151"] }
        target_service_accounts = null
        target_resources        = null
        logging                 = false
      }
      deny-ipv4-ingress = {
        description             = "Disable any ingress"
        direction               = "INGRESS"
        action                  = "deny"
        priority                = 1001
        ranges                  = ["0.0.0.0/0"]
        ports                   = { all = [] }
        target_service_accounts = null
        target_resources        = null
        logging                 = false
      }
    }
  }
  firewall_policy_association = {
    restrict-external = "restrict-external"
  }
}

module "branch-sandbox-open-folder" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  count  = var.fast_features.sandbox ? 1 : 0
  parent = "organizations/${var.organization.id}"
  name   = "Sandbox"
  iam = {
    "roles/logging.admin"                  = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
    "roles/owner"                          = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
    "roles/resourcemanager.folderAdmin"    = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
    "roles/resourcemanager.projectCreator" = concat([module.branch-sandbox-sa[0].iam_email], local.branch_optional_sa_lists.pf-sbox)
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/sandbox"].id, null
    )
  }
}

module "branch-sandbox-gcs" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
  count         = var.fast_features.sandbox ? 1 : 0
  project_id    = var.automation.project_id
  name          = "dev-resman-sbox-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.branch-sandbox-sa[0].iam_email]
  }
}

module "branch-sandbox-sa" {
  source       = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  count        = var.fast_features.sandbox ? 1 : 0
  project_id   = var.automation.project_id
  name         = "dev-resman-sbox-0"
  display_name = "Terraform resman sandbox service account."
  prefix       = var.prefix
}

resource "google_organization_iam_member" "org_policy_admin_sandbox" {
  count  = var.fast_features.sandbox ? 1 : 0
  org_id = var.organization.id
  role   = "roles/orgpolicy.policyAdmin"
  member = module.branch-sandbox-sa[0].iam_email
  condition {
    title       = "org_policy_tag_sandbox_scoped"
    description = "Org policy tag scoped grant for sandbox."
    expression  = <<-END
    resource.matchTag('${var.organization.id}/${var.tag_names.context}', 'sandbox')
    END
  }
}
