variable "project_id" {
  description = "The globally unique identifier for your project, see https://cloud.google.com/resource-manager/docs/creating-managing-projects"
}

variable "psi_project_id" {
  description = "The globally unique identifier of the psi project. This is needed for e.g. resources located there like the WIF"
}

variable "region" {
  description = "A region is a specific geographical location where you can host your resources, see https://cloud.google.com/compute/docs/regions-zones"
}

variable "spoke_network" {
  description = "The fully qualified name of the VPC shared by this project's spoke"
}

variable "spoke_gke_subnetwork" {
  description = "The fully qualified name of a subnet in the VPC shared by this project's spoke"
}

# region CLEANUP dc2dc088-26a7-4026-bf47-b7bcadd89bdf
variable "workload_identity_pool" {
  description = "The workload identity pool of the PSI organization"
}

variable "zone" {
  description = "Regions have three or more zones, see https://cloud.google.com/compute/docs/regions-zones"
}
# endregion CLEANUP dc2dc088-26a7-4026-bf47-b7bcadd89bdf
