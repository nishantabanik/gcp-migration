variable "gcp_project_id" {
  type        = string
  description = "The globally unique identifier of the project (see: https://cloud.google.com/resource-manager/docs/creating-managing-projects)"
}

variable "gcp_region" {
  type        = string
  description = "Specific geographical location where resources are hosted (see: https://cloud.google.com/compute/docs/regions-zones); either \"europe-west3\" (Frankfurt) or \"europe-west4\" (Eemshaven, Netherlands)"
  default     = "europe-west3"
}

variable "gcp_zone" {
  type        = string
  description = "Deployment area within a region (see: https://cloud.google.com/compute/docs/regions-zones); region suffixed with -a/b/c (e.g.: \"europe-west3-a\")"
}

variable "gcp_network" {
  type        = string
  description = "Name of the main VPC"
}

variable "gcp_subnetwork" {
  type        = string
  description = "Name of the main VPC subnet"
}

variable "enable_impersonate_sa" {
  type        = bool
  description = "Enable impersonating service account for the Google Cloud provider"
  default     = false
}
