# Slalom: Default regions
# If you need to change regions from the defaults:
# 1. Change the values of the mappings in the regions variable to the regions you are going to use
# 2. Change the regions in the factory subnet files in the data folder (data/subnets/[dev,landing,prod]/)
regions = {
  # Slalom: Primary region Frankfurt (https://gcloud-compute.com/europe-west3.html)
  primary = "europe-west3"
  # Slalom: Secondary region Netherlands (https://gcloud-compute.com/europe-west4.html)
  secondary = "europe-west4"
}

# Slalom: Onprem DNS resolvers for forwarding zone
dns = {
  onprem = ["10.0.0.2", "10.0.1.2"]
}

# Slalom: DNS zone domains
dns_zone_names = {
  landing = "gcp-psi-de"
  legacy  = "legacy-gcp-psi-de"
  c2p     = "c2p-gcp-psi-de"
  onprem  = "onprem-psi-de"
}
dns_zone_domains = {
  landing = "gcp.psi.de."
  legacy  = "legacy.gcp.psi.de."
  c2p     = "c2p.gcp.psi.de."
  onprem  = "onprem.psi.de."
}

# Slalom: CFIT-628 add onprem static VPN Gateway config
vpn_onprem_static_primary_config = {
  remote_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

# Slalom: Support for the onprem VPN is disabled by default so that no resources are created.
# Example of how to configure the variable to enable the VPN:
# vpn_onprem_primary_config = {
#   peer_external_gateways = {
#     default = {
#       redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
#       # Public IP of VPN partner
#       interfaces = ["1.2.3.4"]
#     }
#   }
#   router_config = {
#     asn = 65501
#     custom_advertise = {
#       all_subnets = false
#       ip_ranges   = {
#         "10.128.0.0/16"   = "gcp"
#         "35.199.192.0/19" = "gcp-dns"
#         "199.36.153.4/30" = "gcp-restricted"
#       }
#     }
#   }
#   tunnels = {
#     "0" = {
#       bgp_peer = {
#         address = "169.254.1.1"
#         asn     = 65500
#       }
#       bgp_session_range               = "169.254.1.2/30"
#       peer_external_gateway_interface = 0
#       shared_secret                   = "ktLDBvM4HXQM2FuGd9bxj8CB"
#       vpn_gateway_interface           = 0
#     }
#     "1" = {
#       bgp_peer = {
#         address = "169.254.2.1"
#         asn     = 64513
#       }
#       bgp_session_range               = "169.254.2.2/30"
#       peer_external_gateway_interface = 1
#       shared_secret                   = "ktLDBvM4HXQM2FuGd9bxj8CB"
#       vpn_gateway_interface           = 1
#     }
#   }
# }

# Slalom: Create local config. Do not change!
outputs_location = null
