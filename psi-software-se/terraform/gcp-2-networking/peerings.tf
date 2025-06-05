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

module "peering-legacy" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc-peering?ref=stable"
  prefix        = "legacy-peering-0"
  local_network = module.legacy-spoke-vpc.self_link
  peer_network  = module.landing-vpc.self_link
  export_local_custom_routes = try(
    var.peering_configs.legacy.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.legacy.export_peer_custom_routes, null
  )
}

