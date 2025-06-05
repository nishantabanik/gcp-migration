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

# tfdoc:file:description Landing DNS zones and peerings setup.

# forwarding to on-prem DNS resolvers

moved {
  from = module.onprem-example-dns-forwarding
  # Slalom: Module name changed
  to = module.landing-dns-fwd-onprem
}

# Slalom: Module name changed
module "landing-dns-fwd-onprem" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id = module.landing-project.project_id
  type       = "forwarding"
  # Slalom: Use variables
  name            = var.dns_zone_names.onprem
  domain          = var.dns_zone_domains.onprem
  description     = "Forwarding zone for ${var.dns_zone_domains.onprem} (TF managed)"
  client_networks = [module.landing-vpc.self_link]
  forwarders      = { for ip in var.dns.onprem : ip => null }
}

moved {
  from = module.reverse-10-dns-forwarding
  to   = module.landing-dns-fwd-onprem-rev-10
}

module "landing-dns-fwd-onprem-rev-10" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id      = module.landing-project.project_id
  type            = "forwarding"
  name            = "root-reverse-10"
  domain          = "10.in-addr.arpa."
  description     = "Forwarding zone for 10.in-addr.arpa. (TF managed)"
  client_networks = [module.landing-vpc.self_link]
  forwarders      = { for ip in var.dns.onprem : ip => null }
}

moved {
  from = module.gcp-example-dns-private-zone
  to   = module.landing-dns-priv-gcp
}

module "landing-dns-priv-gcp" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id = module.landing-project.project_id
  type       = "private"
  # Slalom: Use variables
  name            = var.dns_zone_names.landing
  domain          = var.dns_zone_domains.landing
  description     = "Private zone for ${var.dns_zone_domains.landing} (TF managed)"
  client_networks = [module.landing-vpc.self_link]
  recordsets = {
    "A localhost" = { records = ["127.0.0.1"] }
  }
}

# Google APIs via response policies

module "landing-dns-policy-googleapis" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//dns-response-policy?ref=stable"
  project_id = module.landing-project.project_id
  name       = "googleapis"
  networks = {
    landing = module.landing-vpc.self_link
  }
  rules_file = var.factories_config.dns_policy_rules_file
}
