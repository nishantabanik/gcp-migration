### Identity-Aware Proxy setup for the Web application access

resource "google_iap_brand" "csf_iap_brand" {
  # We need to put here the service account email which is running CI/CD pipeline.
  # It is actually a workaround because we should not present this email to end users on consent screen.
  #
  # See:
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_brand.html#support_email-1
  # https://github.com/hashicorp/terraform-provider-google/issues/20204#issuecomment-2520072440 
  support_email = "psi-de-0-sb-sbox-csf-0@psi-de-0-sbox-csf.iam.gserviceaccount.com"

  application_title = "CSF - IAP protected application"
  project           = var.gcp_project_id
}

resource "google_iap_client" "csf_iap_client" {
  display_name = "CSF IAP default OAuth client."
  brand        = google_iap_brand.csf_iap_brand.name
}


### External application loadbalancer with IAP-support

resource "google_compute_health_check" "elb_health" {
  name = "glb-external-ingress-health"
  http_health_check {
    port         = 80
    proxy_header = "NONE"
    request_path = "/healthz"
  }

}

# The NEGs need to exist in the zones specified by var.lb_neg_zones.
# GKE cluster has to be ready, Nginx Ingress has to be installed and
# nodes of the cluster need to be created in the specified zones.
# If this is not true, the terraform plan will fail.

# At the beginning var.lb_neg_zones has to be set to an empty list.
# Similar to https://stackoverflow.com/q/75110188/
data "google_compute_network_endpoint_group" "negs" {
  count = length(var.lb_neg_zones)
  name  = var.lb_neg_name
  zone  = var.lb_neg_zones[count.index]
}

resource "google_compute_backend_service" "elb_bs" {
  load_balancing_scheme = "EXTERNAL_MANAGED"
  name                  = "glb-external-ingress-bs"
  port_name             = "http"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.elb_health.id]
  
  # request and response timeout for HTTP(S) traffic
  # see: https://cloud.google.com/load-balancing/docs/backend-service#timeout-setting
  # https://cloud.google.com/load-balancing/docs/https#timeouts_and_retries
  timeout_sec           = 600

  iap {
    enabled              = true
    oauth2_client_id     = google_iap_client.csf_iap_client.client_id
    oauth2_client_secret = google_iap_client.csf_iap_client.secret
  }
  dynamic "backend" {
    for_each = data.google_compute_network_endpoint_group.negs
    content {
      group                 = backend.value.self_link
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 100
    }
  }

  # This is required for Nginx Ingress Controller to pass the correct X-Forwarded-Port header value
  # to the upstream (backend) services (crucial for Keycloak as an example).
  # See:
  # https://github.com/kubernetes/ingress-nginx/issues/6358
  # https://github.com/kubernetes/ingress-nginx/issues/11138
  custom_request_headers = ["X-Forwarded-Port: 443"]
}

resource "google_compute_url_map" "elb_um" {
  name            = "glb-external-ingress-um"
  default_service = google_compute_backend_service.elb_bs.id
}

resource "google_compute_ssl_certificate" "default" {
  name = "wildcard-csf-psi-cloud-com-cert"

  # The private key file does not exist in the repository. 
  # It is only available in GitLab CI/CD pipelines.
  # The check and the dummy content is for running local plans.
  private_key = fileexists("data/elb-cert.key") ? file("data/elb-cert.key") : "no-key"
  certificate = file("data/elb-cert.crt")
}

resource "google_compute_target_https_proxy" "elb_thp" {
  name             = "glb-external-ingress-thp"
  url_map          = google_compute_url_map.elb_um.id
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}

# reserved IP address
resource "google_compute_global_address" "elb_ip" {
  name = "glb-external-ingress-ip"
}


resource "google_compute_global_forwarding_rule" "elb_fr" {
  load_balancing_scheme = "EXTERNAL_MANAGED"
  name                  = "glb-external-ingress-fr"
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.elb_thp.id
  ip_address            = google_compute_global_address.elb_ip.id
}
