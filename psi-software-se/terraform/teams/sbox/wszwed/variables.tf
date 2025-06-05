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

variable "enable_impersonate_sa" {
  type        = bool
  description = "Enable impersonating service account for the Google Cloud provider"
  default     = false
}

variable "gcp_network" {
  type        = string
  description = "Name of the main VPC"
}

variable "gcp_subnetwork" {
  type        = string
  description = "Name of the main subnet"
}

variable "prefix" {
  description = "Prefix used for resources that need unique names. Use 9 characters or less."
  type        = string
  default = "psi-de-0"
  validation {
    condition     = try(length(var.prefix), 0) < 10
    error_message = "Use a maximum of 9 characters for prefix."
  }
}

variable "iap" {
  description = "Identity-Aware Proxy for Cloud Run in the LB."
  type = object({
    enabled            = optional(bool, false)
    app_title          = optional(string, "Sandbox app by wszwed")
    oauth2_client_name = optional(string, "IAP Client")
    email              = optional(string)
  })
  default = {}
}

variable "cluster_name" {
  type        = string
  description = "Name of GKE autopilot cluster"
  default = "gke-wito"
}

variable "lb_name" {
  type        = string
  description = "Name of GLB"
  default = "glb-wito"
}

variable "lb_neg_name" {
  type        = string
  description = "Name of Network Endpoint Group to be used by External Load Balancer"
}

variable "lb_neg_zones" {
  type        = list(string)
  description = "List of zones for Network Endpoint Group to be used by External Load Balancer"
  default     = []
}
