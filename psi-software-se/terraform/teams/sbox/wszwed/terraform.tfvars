gcp_project_id        = "psi-de-0-sbox-wszwed"
gcp_region            = "europe-west3"
gcp_zone              = "europe-west3-a"
gcp_network           = "vpc-ew3"
gcp_subnetwork        = "vpc-subnet-1-ew3"
iap                   = {
  enabled = true
  email   = "wszwed@psi.de"
}
lb_neg_name  = "gke-wito-ingress-nginx-80-neg"
lb_neg_zones = ["europe-west3-a", "europe-west3-b", "europe-west3-c"]
