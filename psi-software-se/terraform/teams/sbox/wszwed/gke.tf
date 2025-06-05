data "google_service_account" "kubernetes" {
  project    = var.gcp_project_id
  account_id = "kubernetes-1"
}

module "gke0" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//gke-cluster-autopilot?ref=stable"
  project_id = var.gcp_project_id
  name       = var.cluster_name
  location   = var.gcp_region
  node_locations = var.lb_neg_zones
  vpc_config = {
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
    secondary_range_names = {
      pods     = "pods"
      services = "services"
    }
  }
  private_cluster_config = {
    enable_private_endpoint = false
    master_global_access    = true
  }
  labels = {
    environment = "sandbox"
  }
  node_config = {
    service_account = data.google_service_account.kubernetes.email
  }
  deletion_protection = false
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host  = "https://${module.gke0.cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke0.cluster.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

resource "kubernetes_secret_v1" "iap_oauth_credentials" {
  metadata {
    name      = "iap-oauth-secret"
    namespace = "default"
  }
  data = {
    client_id     = google_iap_client.iap_client.0.client_id
    client_secret = google_iap_client.iap_client.0.secret # Sensitive value
  }
  type = "Opaque"
}

resource "kubernetes_manifest" "backend_config" {
  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "hello-app-backendconfig"
      namespace = "default"
    }
    spec = {
      iap = {
        enabled = true
        oauthclientCredentials = {
          secretName = kubernetes_secret_v1.iap_oauth_credentials.metadata[0].name
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "hello_app_deployment" {
  metadata {
    name = "hello-app"
    namespace = "default" # Deploy to the default namespace
    labels = {
      app = "hello-app"
    }
  }

  spec {
    replicas = 3 # Run two instances of the application for redundancy.
    selector {
      match_labels = {
        app = "hello-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-app"
        }
      }
      spec {
        container {
          image = "nginx:1.23" # Use the latest stable Nginx image.  We'll configure it to serve a simple "Hello" page.
          name = "hello-app"
          port {
            container_port = 80
          }
          # Define a simple configuration for Nginx to serve our "Hello" message.
          env {
            name  = "MESSAGE"
            value = "Hello from GKE!"
          }
          security_context {
            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = false

            capabilities {
              add = []
              drop = ["NET_RAW"]
            }
          }
          liveness_probe {
            http_get {
              path = "/"
              port = "80"

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
          volume_mount {
            name      = "config-volume"
            mount_path = "/usr/share/nginx/html" # Or /var/www/html, depending on your Nginx config
            read_only = true # Recommended for configMaps
          }
        }
        security_context {
          run_as_non_root = true

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        # Toleration is currently required to prevent perpetual diff:
        # https://github.com/hashicorp/terraform-provider-kubernetes/pull/2380
        toleration {
          effect   = "NoSchedule"
          key      = "kubernetes.io/arch"
          operator = "Equal"
          value    = "amd64"
        }
        # Define a volume.
        volume {
          name = "config-volume"
          config_map {
            name = "nginx-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map_v1" "nginx-config" {
  metadata {
    name      = "nginx-config"
    namespace = "default"
  }
  data = {
    "index.html" = <<EOF
<!DOCTYPE html>
<html>
<head>
<title>Hello from GKE</title>
<style>
  body {
    font-family: sans-serif;
    text-align: center;
    padding: 50px;
    background-color: #f0f0f0;
  }
  h1 {
    font-size: 2em;
    color: #4CAF50; /* Green */
  }
</style>
</head>
<body>
  <h1>${"Hello from GKE!"}</h1>
  <p>This application is running in Google Kubernetes Engine.</p>
</body>
</html>
EOF
  }
}

resource "kubernetes_service_v1" "hello_app_service" {
  metadata {
    name      = "hello-app-service"
    namespace = "default"
    labels = {
      app = "hello-app"
    }
    annotations = {
      "cloud.google.com/neg" = jsonencode({
        "exposed_ports" = {
          "80" = {
            "name" = "gke-wito-ingress-nginx-80-neg"
          }
        }
      })
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.hello_app_deployment.spec[0].selector[0].match_labels.app
    }
    port {
      port        = 80
      target_port = kubernetes_deployment_v1.hello_app_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_deployment_v1.hello_app_deployment]
}

resource "kubernetes_service_v1" "hello_app_service2" {
  metadata {
    name      = "hello-app-service2"
    namespace = "default"
    labels = {
      app = "hello-app"
    }
    annotations = {
      "beta.cloud.google.com/backend-config" = jsonencode({"default": kubernetes_manifest.backend_config.manifest.metadata.name})
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.hello_app_deployment.spec[0].selector[0].match_labels.app
    }
    port {
      port        = 80
      target_port = kubernetes_deployment_v1.hello_app_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
    type = "NodePort"
  }
  depends_on = [kubernetes_deployment_v1.hello_app_deployment]
}

resource "google_compute_global_address" "ingress_static_ip" {
  name = "hello-app-ingress-ip"
  project = var.gcp_project_id
}

output "gke_ingress_ip" {
  value = google_compute_global_address.ingress_static_ip.address
}

resource "google_compute_managed_ssl_certificate" "hello_app_certificate" {
  name = "hello-app-managed-cert"
  project = var.gcp_project_id
  managed {
    domains = ["wito.psi-cloud.com"] # Replace with your custom domain(s)
  }
}

# Kubernetes Ingress resource to create the external HTTPS load balancer
resource "kubernetes_ingress_v1" "hello_app_ingress" {
  metadata {
    name      = "hello-app-ingress"
    namespace = "default"
    annotations = {
      # Use the GCE Ingress class to provision a GCP Load Balancer
      "kubernetes.io/ingress.class" = "gce"
      # Specify the global static IP address to use
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress_static_ip.name
      # Specify the managed certificate to use for HTTPS
      "networking.gke.io/managed-certificates" = google_compute_managed_ssl_certificate.hello_app_certificate.name
      # Reference the BackendConfig for the hello-app service
      "beta.cloud.google.com/backend-config" = jsonencode({
        "default" = kubernetes_manifest.backend_config.manifest.metadata.name
      })
      # Disable HTTP, forcing redirection to HTTPS
      "kubernetes.io/ingress.allow-http" = "false"
    }
  }

  spec {
    # Configure TLS using the secret created by the managed certificate
    tls {
      # The secretName is automatically created by the managed certificate resource
      secret_name = google_compute_managed_ssl_certificate.hello_app_certificate.name
      hosts       = ["wito.psi-cloud.com"] # Replace with your custom domain(s)
    }
    # Define routing rules
    rule {
      host = "wito.psi-cloud.com" # Replace with your custom domain
      http {
        path {
          path = "/*" # Match all paths
          backend {
            service {
              name = kubernetes_service_v1.hello_app_service2.metadata[0].name
              port {
                number = kubernetes_service_v1.hello_app_service2.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
  # Ensure the Ingress is created after the service and backend config
  depends_on = [
    kubernetes_service_v1.hello_app_service2,
    kubernetes_manifest.backend_config
  ]
}