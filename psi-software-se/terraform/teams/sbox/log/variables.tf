variable "project_id" {
  type        = string
  description = "The globally unique identifier of the project (see: https://cloud.google.com/resource-manager/docs/creating-managing-projects)"
}

variable "region" {
  type        = string
  description = "Specific geographical location where resources are hosted. Allowed regions are defined in this project's definition in the project factory."
  default     = "europe-west3"
}

variable "zone" {
  type        = string
  description = "Deployment area within a region (see: https://cloud.google.com/compute/docs/regions-zones); region suffixed with -a/b/c (e.g.: \"europe-west3-a\")"
}

variable "network" {
  type        = string
  description = "Name of the main VPC"
}

variable "subnetwork" {
  type        = string
  description = "Name of the main subnet"
}


variable "enable_impersonate_sa" {
  type        = bool
  description = "Enable impersonating service account for the Google Cloud provider"
  default     = false
}

variable "impersonate_service_account" {
  type        = string
  description = "Name of the impersonate service account"
}

variable "iap" {
  description = "Identity-Aware Proxy"
  type = object({
    enabled            = optional(bool, false)
    app_title          = optional(string, "IAP by IDP Team")
    oauth2_client_name = optional(string, "IAP Client")
    email              = optional(string)
  })
  default = {}
}
