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

# tfdoc:file:description Development spoke DNS zones and peerings setup.

#
# Slalom: We use cross project DNS peering for shared environment zone (shared VPC spoke).
#         https://cloud.google.com/dns/docs/zones/zones-overview#peering_zones
#
# Note:   As an alternative to DNS peering, cross project binding can also be used.
#         To configure this, the DNS peering from hub to spoke (module landing-root-dns-peer-*) must be removed
#         and the client_networks (module *-dns-priv) must be changed to the hub VPC.
#         https://cloud.google.com/dns/docs/zones/zones-overview#cross-project_binding
#


# Slalom: Module name changed
module "legacy-dns-priv" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id = module.legacy-spoke-project.project_id
  type       = "private"
  # Slalom: Use variables
  name        = var.dns_zone_names.legacy
  domain      = var.dns_zone_domains.legacy
  description = "Private zone for ${var.dns_zone_domains.legacy} (TF managed)"
  # Slalom: Create private zone in shared VPC spoke
  #client_networks = [module.landing-vpc.self_link]
  client_networks = [module.legacy-spoke-vpc.self_link]
  recordsets = {
    "A localhost" = { records = ["127.0.0.1"] }
  }
}

# Slalom: DNS peering from root zone to shared VPC spoke
module "landing-root-dns-peer-legacy" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id      = module.landing-project.project_id
  type            = "peering"
  name            = var.dns_zone_names.legacy
  domain          = var.dns_zone_domains.legacy
  description     = "Peering zone for ${var.dns_zone_domains.legacy} (TF managed)"
  client_networks = [module.landing-vpc.self_link]
  peer_network    = module.legacy-spoke-vpc.self_link
}


module "legacy-dns-peer-landing-root" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id      = module.legacy-spoke-project.project_id
  type            = "peering"
  name            = "legacy-root-dns-peering"
  domain          = "."
  description     = "Peering zone for . (TF managed)"
  client_networks = [module.legacy-spoke-vpc.self_link]
  peer_network    = module.landing-vpc.self_link
}


module "legacy-dns-peer-landing-rev-10" {
  source          = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id      = module.legacy-spoke-project.project_id
  type            = "peering"
  name            = "legacy-reverse-10-dns-peering"
  domain          = "10.in-addr.arpa."
  description     = "Peering zone for 10.in-addr.arpa. (TF managed)"
  client_networks = [module.legacy-spoke-vpc.self_link]
  peer_network    = module.landing-vpc.self_link
}
