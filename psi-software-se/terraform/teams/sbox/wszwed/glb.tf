resource "google_compute_global_address" "default" {
  count   = 1
  project = module.project.project_id
  name    = "glb-ip"
}

output "global_address" {
  value = google_compute_global_address.default.0.address
}

data "kubernetes_service" "my_service" {
  metadata {
    name      = "hello-app-service"
    namespace = "default"
  }
  depends_on = [kubernetes_service_v1.hello_app_service]
}
locals {
  service_zones = jsondecode(data.kubernetes_service.my_service.metadata.0.annotations["cloud.google.com/neg-status"]).zones
}

output "service_zones" {
  value = local.service_zones
}

data "google_compute_network_endpoint_group" "negs" {
  count = length(local.service_zones)
  name = var.lb_neg_name
  zone = local.service_zones[count.index]
}

module "glb" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric.git//modules/net-lb-app-ext"
  project_id = var.gcp_project_id
  name       = var.lb_name
  use_classic_version = false
  forwarding_rules_config = {
    "" = {
      address = google_compute_global_address.default[0].address
    }
  }
  backend_service_configs = {
    default = {
      backends = [for k,v in data.google_compute_network_endpoint_group.negs:
        ({
          backend        = data.google_compute_network_endpoint_group.negs[k].self_link
          balancing_mode = "RATE"
          max_rate = {
            per_endpoint = 100
          }
        })
      ]
      # Add reference to the health check
      health_checks = ["http-health-check"]
      port_name = "http" # Should match the port name exposed by your GKE service
      protocol = "HTTP"
      security_policy = null
      custom_request_headers = ["X-Forwarded-Port: 443"]
      iap_config = try({
        oauth2_client_id     = google_iap_client.iap_client[0].client_id,
        oauth2_client_secret = google_iap_client.iap_client[0].secret
      }, null)
    }
  }
  # Define a health check for the GKE backend
  health_check_configs = {
    "http-health-check" = {
      http = {
        port = 80      # Port your GKE service listens on
        request_path = "/"     # Path for your health check endpoint in GKE
      }
      # Name of the health check
      check_interval_sec  = 5
      timeout_sec         = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }
  protocol = "HTTPS"
  ssl_certificates = {
    managed_configs = {
      default = {
        domains = ["psi.witodev.com"]
      }
    }
  }
}
