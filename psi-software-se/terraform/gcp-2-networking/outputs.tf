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
  host_project_ids = {
    prod-landing   = module.landing-project.project_id
    legacy-spoke-0 = module.legacy-spoke-project.project_id
    c2p-spoke-0    = module.c2p-spoke-project.project_id
  }
  host_project_numbers = {
    prod-landing   = module.landing-project.number
    legacy-spoke-0 = module.legacy-spoke-project.number
    c2p-spoke-0    = module.c2p-spoke-project.number
  }
  subnet_self_links = {
    prod-landing   = module.landing-vpc.subnet_self_links
    legacy-spoke-0 = module.legacy-spoke-vpc.subnet_self_links
    c2p-spoke-0    = module.c2p-spoke-vpc.subnet_self_links
  }
  tfvars = {
    host_project_ids     = local.host_project_ids
    host_project_numbers = local.host_project_numbers
    subnet_self_links    = local.subnet_self_links
    vpc_self_links       = local.vpc_self_links
    # Slalom: Added regions and DNS zones to output
    networking_regions = local.networking_regions
    vpc_dns_domains    = local.vpc_dns_domains
  }
  vpc_self_links = {
    prod-landing = module.landing-vpc.self_link

    legacy-spoke-0 = module.legacy-spoke-vpc.self_link
    c2p-spoke-0    = module.c2p-spoke-vpc.self_link
  }
  # Slalom: Add regions to output. Later used in project factory (demo-projects.sh).
  networking_regions = {
    primary   = var.regions.primary
    secondary = var.regions.secondary
  }
  # Slalom: VPC DNS domains
  vpc_dns_domains = {
    prod-landing   = module.landing-dns-priv-gcp.domain
    legacy-spoke-0 = module.legacy-dns-priv.domain
    c2p-spoke-0    = module.c2p-dns-priv.domain
  }
}

# generate tfvars file for subsequent stages

resource "local_file" "tfvars" {
  for_each        = var.outputs_location == null ? {} : { 1 = 1 }
  file_permission = "0644"
  filename        = "${try(pathexpand(var.outputs_location), "")}/tfvars/2-networking.auto.tfvars.json"
  content         = jsonencode(local.tfvars)
}

resource "google_storage_bucket_object" "tfvars" {
  bucket  = var.automation.outputs_bucket
  name    = "tfvars/2-networking.auto.tfvars.json"
  content = jsonencode(local.tfvars)
}

# outputs

output "cloud_dns_inbound_policy" {
  description = "IP Addresses for Cloud DNS inbound policy."
  value       = [for s in module.landing-vpc.subnets : cidrhost(s.ip_cidr_range, 2)]
}

output "host_project_ids" {
  description = "Network project ids."
  value       = local.host_project_ids
}

output "host_project_numbers" {
  description = "Network project numbers."
  value       = local.host_project_numbers
}

output "shared_vpc_self_links" {
  description = "Shared VPC host projects."
  value       = local.vpc_self_links
}

output "tfvars" {
  description = "Terraform variables file for the following stages."
  sensitive   = true
  value       = local.tfvars
}

output "vpn_gateway_endpoints" {
  description = "External IP Addresses for the GCP VPN gateways."
  value = var.vpn_onprem_primary_config == null ? null : {
    onprem-primary = {
      for v in module.landing-to-onprem-primary-vpn[0].gateway.vpn_interfaces :
      v.id => v.ip_address
    }
  }
}

output "vpn_static_gateway_endpoints" {
  description = "External IP Addresses for the GCP Static VPN gateways."
  value = var.vpn_onprem_static_primary_config == null ? null : {
    onprem-primary = module.landing-to-onprem-static-primary-vpn[0].address
  }
}
