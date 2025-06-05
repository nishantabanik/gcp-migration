module "cloud_run" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//cloud-run-v2?ref=stable"
  project_id = var.gcp_project_id
  name       = "complex-cloud-build-run-sample-app"
  ingress    = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  region     = var.gcp_region
  containers = {
    app = {
      image = "europe-west3-docker.pkg.dev/psi-de-0-sbox-cft/container-images/sample-app:snapshot"
      ports = {
        app = {
          container_port = 8080
        }
    }
    }    
  }
  iam = {
    "roles/run.invoker" = ["domain:psi.de"]
  }
}
