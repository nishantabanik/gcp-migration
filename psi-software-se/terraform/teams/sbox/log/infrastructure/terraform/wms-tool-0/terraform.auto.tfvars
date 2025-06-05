project_id           = "psi-de-0-wms-tool-0"
region               = "europe-west3"
spoke_network        = "projects/psi-de-0-dev-net-spoke-0/global/networks/dev-spoke-0"
spoke_gke_subnetwork = "projects/psi-de-0-dev-net-spoke-0/regions/europe-west3/subnetworks/dev-gke-nodes-ew3"
zone                 = "europe-west3-a"

# region CLEANUP dc2dc088-26a7-4026-bf47-b7bcadd89bdf
workload_identity_pool = "psi-de-0-bootstrap"
psi_project_id         = "504787948326"
# endregion END CLEANUP dc2dc088-26a7-4026-bf47-b7bcadd89bdf
