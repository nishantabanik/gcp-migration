/**
 * Copyright 2025 Slalom GmbH
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

# tfdoc:file:description VPN between landing and c2p.

module "landing-to-c2p-ha-vpn" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpn-ha?ref=stable"
  project_id = module.landing-project.project_id
  network    = module.landing-vpc.self_link
  region     = var.regions.primary
  name       = "vpn-landing-to-c2p-${local.region_shortnames[var.regions.primary]}"
  peer_gateways = {
    default = { gcp = module.c2p-to-landing-ha-vpn.self_link }
  }
  router_config = {
    name = "vpn-landing-to-c2p-${local.region_shortnames[var.regions.primary]}"
    asn  = 64514
    custom_advertise = {
      all_subnets = true
      ip_ranges = {
        "10.0.0.0/8"     = "default",
        "172.16.0.0/12"  = "default",
        "192.168.0.0/16" = "default"
      }
    }
  }
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_session_range     = "169.254.1.2/30"
      vpn_gateway_interface = 0
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_session_range     = "169.254.2.2/30"
      vpn_gateway_interface = 1
    }
  }
}

module "c2p-to-landing-ha-vpn" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpn-ha?ref=stable"
  project_id = module.c2p-spoke-project.project_id
  network    = module.c2p-spoke-vpc.self_link
  region     = var.regions.primary
  name       = "vpn-c2p-to-landing-${local.region_shortnames[var.regions.primary]}"
  router_config = {
    name = "vpn-c2p-to-landing-${local.region_shortnames[var.regions.primary]}"
    asn  = 64513
  }
  peer_gateways = {
    default = { gcp = module.landing-to-c2p-ha-vpn.self_link }
  }
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64514
      }
      bgp_session_range     = "169.254.1.1/30"
      shared_secret         = module.landing-to-c2p-ha-vpn.random_secret
      vpn_gateway_interface = 0
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64514
      }
      bgp_session_range     = "169.254.2.1/30"
      shared_secret         = module.landing-to-c2p-ha-vpn.random_secret
      vpn_gateway_interface = 1
    }
  }
}
