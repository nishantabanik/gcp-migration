/**
 * Copyright 2025 Slalom GmbH
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

# tfdoc:file:description Legacy spoke VPC and related resources.

module "legacy-spoke-project" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//project?ref=stable"
  billing_account = var.billing_account.id
  name            = "legacy-net-spoke-0"
  parent          = var.folder_ids.networking-dev
  prefix          = var.prefix
  services = [
    "container.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
    "vpcaccess.googleapis.com"
  ]
  shared_vpc_host_config = {
    enabled = true
  }
  metric_scopes = [module.landing-project.project_id]
  group_iam = {
    "app-gcp-legacy-network-viewers@psi.de" = [
      "roles/compute.networkViewer",
    ]
  }
  iam = {
    "roles/dns.admin" = compact([
      try(local.service_accounts.project-factory-legacy, null),
    ])
  }
}

module "legacy-spoke-vpc" {
  source      = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc?ref=stable"
  project_id  = module.legacy-spoke-project.project_id
  name        = "legacy-spoke-0"
  mtu         = 1500
  data_folder = "${var.factories_config.data_dir}/subnets/legacy"
  psa_config  = try(var.psa_ranges.legacy, null)
  # set explicit routes for googleapis in case the default route is deleted
  create_googleapis_routes = {
    private    = true
    restricted = true
  }
}

module "legacy-spoke-firewall" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc-firewall?ref=stable"
  project_id = module.legacy-spoke-project.project_id
  network    = module.legacy-spoke-vpc.name
  default_rules_config = {
    disabled = true
  }
  factories_config = {
    cidr_tpl_file = "${var.factories_config.data_dir}/cidrs.yaml"
    rules_folder  = "${var.factories_config.data_dir}/firewall-rules/legacy"
  }
}

module "legacy-spoke-cloudnat" {
  for_each       = toset(values(module.legacy-spoke-vpc.subnet_regions))
  source         = "git@gitlab.com:psi-software-se/terraform/modules.git//net-cloudnat?ref=stable"
  project_id     = module.legacy-spoke-project.project_id
  region         = each.value
  name           = "legacy-nat-${local.region_shortnames[each.value]}"
  router_create  = true
  router_network = module.legacy-spoke-vpc.name
  router_asn     = 4200001024
  logging_filter = "ERRORS_ONLY"
}

# Create delegated grants for stage3 service accounts
resource "google_project_iam_binding" "legacy_spoke_project_iam_delegated" {
  project = module.legacy-spoke-project.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  members = compact([
    try(local.service_accounts.project-factory-legacy, null),
  ])
  condition {
    title       = "legacy_stage3_sa_delegated_grants"
    description = "Legacy host project delegated grants."
    expression = format(
      "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly([%s])",
      join(",", formatlist("'%s'", local.stage3_sas_delegated_grants))
    )
  }
}
