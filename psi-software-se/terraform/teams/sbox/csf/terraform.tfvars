gcp_project_id = "psi-de-0-sbox-csf"
gcp_region     = "europe-west3"

gcp_network    = "vpc-ew3"
gcp_subnetwork = "vpc-subnet-1-ew3"

# coming from Nginx Ingress Controller ClusterIP service annotation cloud.google.com/neg
# see the nginx folder
lb_neg_name  = "gke-1-ingress-nginx-80-neg"
lb_neg_zones = ["europe-west3-a", "europe-west3-b", "europe-west3-c"]
