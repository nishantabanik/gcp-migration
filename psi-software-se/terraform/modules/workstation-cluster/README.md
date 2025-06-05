# Public Google Cloud Workstation cluster

This module allows to create a public workstation cluster with associated workstation configs and workstations.
In addition to this it allows to set up IAM bindings for the workstation configs and the workstations.

## Simple example

Simple example showing how to create a cluster with publicly accessible workstations using the default base image.

```hcl
locals {
  project_id   = "PROJECT-ID"
  region       = "europe-west4"
  machine_type = "t2d-standard-8"
}

module "vpc" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//net-vpc?ref=stable"
  project_id = local.project_id
  name       = "vpc-workstations-0"
  subnets = [
    {
      ip_cidr_range = "10.1.4.0/24"
      name          = "vpc-workstations-0"
      region        = local.region
    }
  ]
}

module "workstation-cluster" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//workstation-cluster?ref=stable"
  project_id = local.project_id
  id         = "workstations-cluster"
  location   = local.region
  network_config = {
    network    = module.vpc.id
    subnetwork = module.vpc.subnets["${local.region}/vpc-workstations-0"].id
  }
  workstation_configs = {
    workstations-config-base = {
      container = {
        image = "us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest"
      }
      gce_instance = {
        machine_type      = local.machine_type
        pool_size         = 0
        boot_disk_size_gb = 500
      }
    }
  }
}
```

## Custom image

Example showing how to create a cluster with publicly accessible workstation that run a custom image.

```hcl
module "workstation-cluster" {
  source     = "./fabric/modules/workstation-cluster"
  project_id = var.project_id
  id         = "my-workstation-cluster"
  location   = var.region
  network_config = {
    network    = var.vpc.self_link
    subnetwork = var.subnet.self_link
  }
  workstation_configs = {
    my-workstation-config = {
      container = {
        image = "repo/my-image:v10.0.0"
        args  = ["--arg1", "value1", "--arg2", "value2"]
        env = {
          VAR1 = "VALUE1"
          VAR2 = "VALUE2"
        }
        working_dir = "/my-dir"
      }
      workstations = {
        my-workstation = {
          labels = {
            team = "my-team"
          }
        }
      }
    }
  }
}
```

## IAM

Example showing how to grant IAM roles on the workstation configuration or workstation.

```hcl
module "workstation-cluster" {
  source     = "./fabric/modules/workstation-cluster"
  project_id = var.project_id
  id         = "my-workstation-cluster"
  location   = var.region
  network_config = {
    network    = var.vpc.self_link
    subnetwork = var.subnet.self_link
  }
  workstation_configs = {
    my-workstation-config = {
      workstations = {
        my-workstation = {
          labels = {
            team = "my-team"
          }
          iam = {
            "roles/workstations.user" = ["user:user1@my-org.com"]
          }
        }
      }
      iam = {
        "roles/viewer" = ["group:group1@my-org.com"]
      }
      iam_bindings = {
        workstations-config-viewer = {
          role    = "roles/viewer"
          members = ["group:group2@my-org.com"]
          condition = {
            title      = "limited-access"
            expression = "resource.name.startsWith('my-')"
          }
        }
      }
      iam_bindings_additive = {
        workstations-config-editor = {
          role   = "roles/editor"
          member = "group:group3@my-org.com"
          condition = {
            title      = "limited-access"
            expression = "resource.name.startsWith('my-')"
          }
        }
      }
    }
  }
}
```

<!-- BEGIN TFDOC -->
<!-- END TFDOC -->

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_workstations_workstation.workstations](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation) | resource |
| [google-beta_google_workstations_workstation_cluster.cluster](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_cluster) | resource |
| [google-beta_google_workstations_workstation_config.configs](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_config) | resource |
| [google-beta_google_workstations_workstation_config_iam_binding.authoritative](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_config_iam_binding) | resource |
| [google-beta_google_workstations_workstation_config_iam_binding.bindings](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_config_iam_binding) | resource |
| [google-beta_google_workstations_workstation_config_iam_member.bindings](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_config_iam_member) | resource |
| [google-beta_google_workstations_workstation_iam_binding.authoritative](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_iam_binding) | resource |
| [google-beta_google_workstations_workstation_iam_binding.bindings](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_iam_binding) | resource |
| [google-beta_google_workstations_workstation_iam_member.bindings](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_workstations_workstation_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Workstation cluster annotations. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name. | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain. | `string` | `null` | no |
| <a name="input_id"></a> [id](#input\_id) | Workstation cluster ID. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Workstation cluster labels. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Location. | `string` | n/a | yes |
| <a name="input_network_config"></a> [network\_config](#input\_network\_config) | Network configuration. | <pre>object({<br>    network    = string<br>    subnetwork = string<br>  })</pre> | n/a | yes |
| <a name="input_private_cluster_config"></a> [private\_cluster\_config](#input\_private\_cluster\_config) | Private cluster config. | <pre>object({<br>    enable_private_endpoint = optional(bool, false)<br>    allowed_projects        = optional(list(string))<br>  })</pre> | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Cluster ID. | `string` | n/a | yes |
| <a name="input_workstation_configs"></a> [workstation\_configs](#input\_workstation\_configs) | Workstation configurations. | <pre>map(object({<br>    annotations = optional(map(string))<br>    container = optional(object({<br>      image       = optional(string)<br>      command     = optional(list(string), [])<br>      args        = optional(list(string), [])<br>      working_dir = optional(string)<br>      env         = optional(map(string), {})<br>      run_as_user = optional(string)<br>    }))<br>    display_name       = optional(string)<br>    enable_audit_agent = optional(bool)<br>    encryption_key = optional(object({<br>      kms_key                 = string<br>      kms_key_service_account = string<br>    }))<br>    gce_instance = optional(object({<br>      machine_type                 = optional(string)<br>      service_account              = optional(string)<br>      service_account_scopes       = optional(list(string), [])<br>      pool_size                    = optional(number)<br>      boot_disk_size_gb            = optional(number)<br>      tags                         = optional(list(string))<br>      disable_public_ip_addresses  = optional(bool, false)<br>      enable_nested_virtualization = optional(bool, false)<br>      shielded_instance_config = optional(object({<br>        enable_secure_boot          = optional(bool, false)<br>        enable_vtpm                 = optional(bool, false)<br>        enable_integrity_monitoring = optional(bool, false)<br>      }))<br>      enable_confidential_compute = optional(bool, false)<br>      accelerators = optional(list(object({<br>        type  = optional(string)<br>        count = optional(number)<br>      })), [])<br>    }))<br>    iam = optional(map(list(string)), {})<br>    iam_bindings = optional(map(object({<br>      role    = string<br>      members = list(string)<br>    })), {})<br>    iam_bindings_additive = optional(map(object({<br>      role   = string<br>      member = string<br>    })), {})<br>    idle_timeout = optional(string)<br>    labels       = optional(map(string))<br>    persistent_directories = optional(list(object({<br>      mount_path = optional(string)<br>      gce_pd = optional(object({<br>        size_gb         = optional(number)<br>        fs_type         = optional(string)<br>        disk_type       = optional(string)<br>        source_snapshot = optional(string)<br>        reclaim_policy  = optional(string)<br>      }))<br>    })), [])<br>    running_timeout = optional(string)<br>    replica_zones   = optional(list(string))<br>    workstations = optional(map(object({<br>      annotations  = optional(map(string))<br>      display_name = optional(string)<br>      env          = optional(map(string))<br>      iam          = optional(map(list(string)), {})<br>      iam_bindings = optional(map(object({<br>        role    = string<br>        members = list(string)<br>      })), {})<br>      iam_bindings_additive = optional(map(object({<br>        role   = string<br>        member = string<br>      })), {})<br>      labels = optional(map(string))<br>    })), {})<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Workstation cluster id. |
| <a name="output_workstation_configs"></a> [workstation\_configs](#output\_workstation\_configs) | Workstation configurations. |
| <a name="output_workstations"></a> [workstations](#output\_workstations) | Workstations. |
<!-- END_TF_DOCS -->