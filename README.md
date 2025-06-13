# Terraform

## Build Environment (Assuming Setup already done)
Run the following GitHub actions on the correct branch:
1) Terraform Test and Plan
        Check the plan!
2) Terraform Deployment

Terraform Destroy can be used to destroy the infrastructure completely.

# Setup Environment

## Prerequisites
1. Create a Github classic token for the repo called GH_TOKEN
Scope should be as follows:
        workflow
        write:org
        admin:repo_hook

2. Create the new GCP project
3. Enable billing for the new project
4. Enable the Cloud Key Management Service (KMS) API for the project. 
Note: I have tried doing this in my script but it failed so manual for now

The above are the only tasks that you need to execute manually in the GCP console. 
Please try and stick to automation for everything else from now on - we don't want drift!
5. You must have the following installed locally to bootstrap this:
        GitHub CLI (gh --version to check)
        GCP CLI (gcloud version to check)
Authenticate to both.
        gh auth login
        gcloud auth login
Set the project
        gcloud config set project PROJECT_ID
Check the current project
        gcloud config get-value project 
6. Enable googleapis for the new GCP project
        gcloud services enable iam.googleapis.com

## Bootstrap Terraform
1. Update the /scrips/setup_tf/config.env file with correct values
2. Manually run /scripts/setup_tf/create_bootstrap_sa.sh. This will create the bootstrap service account and store as GitHub secret.

Store the resultant bootstrap json somewhere sensible. Normally stores to /home/<user>/terraform-bootstrap.json

### Environment Setup
Manually run Setup Terraform State (.github/workflows/setup-tf-state.yml) GitHub Action. This will create the service account needed for Terraform as well as the state bucket.
Note: The run will stop expecting authentication with the following message: 
        ! First copy your one-time code: 00E5-F620
        Open this URL to continue in your web browser: https://github.com/login/device
        failed to authenticate via web browser: context deadline exceeded
        Error: Process completed with exit code 1.
Follow instructions and the run will continue or rerun if it has stopped


# Terraform
## Project Structure

terraform-project/
├── main.tf                   # Root module calling modules
├── variables.tf             # Variable definitions, including maps
├── outputs.tf               # Outputs for resource details
├── providers.tf             # Google provider configuration
├── modules/
│   ├── artifact_registry/
│   │   ├── main.tf          # Artifact Registry resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── compute_address/
│   │   ├── main.tf          # Compute Address resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── compute_firewall/
│   │   ├── main.tf          # Compute Firewall resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── storage_bucket/
│   │   ├── main.tf          # Storage Bucket resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── service_account/
│   │   ├── main.tf          # Service Account resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── compute_network/
│   │   ├── main.tf          # Compute Network resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── compute_subnetwork/
│   │   ├── main.tf          # Compute Subnetwork resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── compute_router/
│   │   ├── main.tf          # Compute Router resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── compute_route/
│   │   ├── main.tf          # Compute Route resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   ├── compute_resource_policy/
│   │   ├── main.tf          # Compute Resource Policy resource
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   └── README.md        # Module documentation
│   └── kms_key_ring/
│       ├── main.tf          # KMS Key Ring resource
│       ├── variables.tf     # Module variables
│       ├── outputs.tf       # Module outputs
│       └── README.md        # Module documentation
│   └── container_cluster/    # New module for GKE clusters
│       ├── main.tf           # GKE cluster resource
│       ├── variables.tf      # Module variables
│       ├── outputs.tf        # Module outputs
│       └── README.md         # Module documentation
├── terraform.tfvars         # Variable values
└── README.md                # Project documentation


# Scribbles
## Github Secrets
GCP_PROJECT_ID
projectid-type-store-env-region
e.g. crl-data-store-uat-eu-west-2

#setup new project todo
create secrets
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
        SONAR_PROJECT_KEY: ${{ vars.SONAR_PROJECT_KEY }}
        SONAR_PROJECT_NAME: ${{ vars.SONAR_PROJECT_NAME }}
        SONAR_PROJECT_VERSION: ${{ vars.SONAR_PROJECT_VERSION }}

# Cleanup
## Destroy Environment
cd terraform
terraform destroy -var-file="environments/dev.tfvars"

## Delete State bucket  ??? sji
gsutil rm -r gs://terraform-state-bucket



# Deployment
cd ArchesTerraform/envs/dev

terraform fmt / lint
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Storage Buckets

## Data

## Logs

## Artifacts

## State
Terraform

#todopatching strategy for cluster! sji


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_artifact_registry"></a> [artifact\_registry](#module\_artifact\_registry) | ./modules/artifact_registry | n/a |
| <a name="module_compute_address"></a> [compute\_address](#module\_compute\_address) | ./modules/compute_address | n/a |
| <a name="module_compute_firewall"></a> [compute\_firewall](#module\_compute\_firewall) | ./modules/compute_firewall | n/a |
| <a name="module_compute_network"></a> [compute\_network](#module\_compute\_network) | ./modules/compute_network | n/a |
| <a name="module_compute_router"></a> [compute\_router](#module\_compute\_router) | ./modules/compute_router | n/a |
| <a name="module_compute_subnetwork"></a> [compute\_subnetwork](#module\_compute\_subnetwork) | ./modules/compute_subnetwork | n/a |
| <a name="module_container_cluster"></a> [container\_cluster](#module\_container\_cluster) | ./modules/container_cluster | n/a |
| <a name="module_kms_key_ring"></a> [kms\_key\_ring](#module\_kms\_key\_ring) | ./modules/kms | n/a |
| <a name="module_node_pools"></a> [node\_pools](#module\_node\_pools) | ./modules/container_node_pool | n/a |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | ./modules/service_account | n/a |
| <a name="module_snapshot_policy"></a> [snapshot\_policy](#module\_snapshot\_policy) | ./modules/compute_resource_policy | n/a |
| <a name="module_storage_bucket"></a> [storage\_bucket](#module\_storage\_bucket) | ./modules/storage_bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.artifactregistry_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.cloudresourcemanager_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.compute_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.container_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.iam_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.kms_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.storage_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addresses"></a> [addresses](#input\_addresses) | Map of compute addresses | <pre>map(object({<br/>    name         = string<br/>    address      = string<br/>    address_type = string<br/>    network_tier = string<br/>    purpose      = string<br/>  }))</pre> | n/a | yes |
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Map of storage buckets | <pre>map(object({<br/>    name                        = string<br/>    location                    = string<br/>    storage_class               = string<br/>    force_destroy               = bool<br/>    public_access_prevention    = string<br/>    uniform_bucket_level_access = bool<br/>    cors = optional(list(object({<br/>      max_age_seconds = number<br/>      method          = list(string)<br/>      origin          = list(string)<br/>      response_header = list(string)<br/>    })))<br/>    encryption = optional(object({<br/>      default_kms_key_name = string<br/>    }))<br/>    logging = optional(object({<br/>      log_bucket        = string<br/>      log_object_prefix = string<br/>    }))<br/>    soft_delete_policy = optional(object({<br/>      retention_duration_seconds = number<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | Map of GKE cluster configurations for different environments | <pre>map(object({<br/>    name                     = string<br/>    location                 = string<br/>    node_version             = optional(string)<br/>    min_master_version       = optional(string)<br/>    network                  = string<br/>    subnetwork               = string<br/>    initial_node_count       = number<br/>    remove_default_node_pool = bool<br/>    node_config = object({<br/>      disk_size_gb    = number<br/>      disk_type       = string<br/>      image_type      = string<br/>      logging_variant = string<br/>      machine_type    = string<br/>      metadata        = map(string)<br/>      oauth_scopes    = list(string)<br/>      service_account = string<br/>      shielded_instance_config = object({<br/>        enable_integrity_monitoring = bool<br/>      })<br/>      workload_metadata_config = object({<br/>        mode = string<br/>      })<br/>      labels = map(string)<br/>      tags   = list(string)<br/>    })<br/>    ip_allocation_policy = object({<br/>      cluster_secondary_range_name  = string<br/>      services_secondary_range_name = string<br/>      stack_type                    = optional(string)<br/>      pod_cidr_overprovision_config = optional(object({<br/>        disabled = bool<br/>      }))<br/>      additional_pod_ranges_config = object({<br/>        pod_range_names = list(string)<br/>      })<br/>    })<br/>    addons_config = object({<br/>      dns_cache_config = optional(object({<br/>        enabled = bool<br/>      }))<br/>      gce_persistent_disk_csi_driver_config = optional(object({<br/>        enabled = bool<br/>      }))<br/>      horizontal_pod_autoscaling = object({<br/>        disabled = bool<br/>      })<br/>      http_load_balancing = object({<br/>        disabled = bool<br/>      })<br/>      network_policy_config = object({<br/>        disabled = bool<br/>      })<br/>    })<br/>    cluster_autoscaling = optional(object({<br/>      autoscaling_profile = string<br/>    })) # If not provided, this will be null. Module needs dynamic block.<br/><br/>    # cluster_telemetry is passed to the module, but the module currently<br/>    # doesn't use it in the google_container_cluster resource.<br/>    # Making it optional here. If you intend to use it, the module's main.tf<br/>    # would need a `cluster_telemetry` block.<br/>    cluster_telemetry = optional(object({<br/>      type = string<br/>    })) # If not provided, this will be null.<br/><br/>    database_encryption = optional(object({<br/>      state    = string<br/>      key_name = string<br/>      }), {<br/>      # Default to DECRYPTED if not specified<br/>      state    = "DECRYPTED"<br/>      key_name = ""<br/>    })<br/><br/>    default_max_pods_per_node = number<br/>    default_snat_status = object({<br/>      disabled = bool<br/>    })<br/>    description           = string<br/>    enable_shielded_nodes = optional(bool, true) # Default to true if not specified<br/><br/>    logging_config = object({<br/>      enable_components = list(string)<br/>    })<br/>    maintenance_policy = object({<br/>      recurring_window = object({<br/>        end_time   = string<br/>        recurrence = string<br/>        start_time = string<br/>      })<br/>    })<br/><br/>    master_auth = optional(object({<br/>      client_certificate_config = object({<br/>        issue_client_certificate = bool<br/>      })<br/>      }), {<br/>      # Default client_certificate_config if not specified<br/>      client_certificate_config = { issue_client_certificate = false }<br/>    })<br/>    master_authorized_networks_config = object({<br/>      cidr_blocks = list(object({<br/>        cidr_block   = string<br/>        display_name = string<br/>      }))<br/>    })<br/>    monitoring_config = object({<br/>      advanced_datapath_observability_config = object({<br/>        enable_metrics = bool<br/>        enable_relay   = bool<br/>      })<br/>      enable_components = list(string)<br/>    })<br/>    network_policy = object({<br/>      enabled  = bool<br/>      provider = optional(string)<br/>    })<br/>    networking_mode = string<br/><br/>    node_pool_defaults = optional(object({<br/>      node_config_defaults = object({<br/>        logging_variant = string<br/>      })<br/>    })) # If not provided, this will be null. Module needs dynamic block.<br/><br/>    notification_config = object({<br/>      pubsub = object({<br/>        enabled = bool<br/>      })<br/>    })<br/><br/>    # PodSecurityPolicy is deprecated. Defaulting to disabled.<br/>    pod_security_policy_config = optional(object({<br/>      enabled = bool<br/>      }), {<br/>      enabled = false<br/>    })<br/><br/>    private_cluster_config = object({<br/>      enable_private_endpoint     = optional(bool)<br/>      enable_private_nodes        = bool<br/>      private_endpoint_subnetwork = optional(string) # Add this line<br/>      master_ipv4_cidr_block      = optional(string)<br/>      master_global_access_config = object({<br/>        enabled = bool<br/>      })<br/>    })<br/>    protect_config = object({<br/>      workload_config = object({<br/>        audit_mode = string<br/>      })<br/>    })<br/>    release_channel = object({<br/>      channel = string<br/>    })<br/>    security_posture_config = object({<br/>      mode               = string<br/>      vulnerability_mode = string<br/>    })<br/><br/>    service_external_ips_config = optional(object({<br/>      enabled = bool<br/>      }), {<br/>      enabled = false # Default to disabled if not specified<br/>    })<br/>    vertical_pod_autoscaling = object({<br/>      enabled = bool<br/>    })<br/>    workload_identity_config = object({<br/>      workload_pool = string<br/>    })<br/>    node_pools = map(object({<br/>      name               = string<br/>      machine_type       = string<br/>      disk_size_gb       = number<br/>      disk_type          = string<br/>      image_type         = string<br/>      auto_repair        = bool<br/>      auto_upgrade       = bool<br/>      min_node_count     = number<br/>      max_node_count     = number<br/>      initial_node_count = number<br/>      max_pods_per_node  = number<br/>      location_policy    = string<br/>      max_surge          = number<br/>      max_unavailable    = number<br/>      preemptible        = bool<br/>      spot               = bool<br/>      labels             = map(string)<br/>      tags               = list(string)<br/>      metadata           = map(string)<br/>      node_taints = list(object({<br/>        key    = string<br/>        value  = string<br/>        effect = string<br/>      }))<br/>      gpu_type = object({<br/>        type  = string<br/>        count = number<br/>      })<br/>      shielded_instance_config = object({<br/>        enable_secure_boot          = bool<br/>        enable_integrity_monitoring = bool<br/>      })<br/>      workload_metadata_config = object({<br/>        mode = string<br/>      })<br/>      network_config = object({<br/>        enable_private_nodes = bool<br/>        pod_range            = string<br/>      })<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_common_labels"></a> [common\_labels](#input\_common\_labels) | Common labels to apply to resources | `map(string)` | n/a | yes |
| <a name="input_firewalls"></a> [firewalls](#input\_firewalls) | Map of firewall rules | <pre>map(object({<br/>    name               = string<br/>    network            = string<br/>    direction          = string<br/>    priority           = number<br/>    source_ranges      = optional(list(string), [])<br/>    destination_ranges = optional(list(string), [])<br/>    target_tags        = optional(list(string), [])<br/>    allow = list(object({<br/>      protocol = string<br/>      ports    = optional(list(string))<br/>    }))<br/>    description = string<br/>  }))</pre> | n/a | yes |
| <a name="input_format"></a> [format](#input\_format) | The format for artifact registries | `string` | n/a | yes |
| <a name="input_gke_version"></a> [gke\_version](#input\_gke\_version) | GKE version to use for clusters | `string` | n/a | yes |
| <a name="input_kms_key_rings"></a> [kms\_key\_rings](#input\_kms\_key\_rings) | n/a | <pre>map(object({<br/>    name     = string<br/>    location = string<br/>    crypto_keys = map(object({<br/>      name                = string<br/>      service_account_key = string<br/>    }))<br/>    labels = map(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location (zone or region) for resources | `string` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode) | The mode for artifact registries | `string` | n/a | yes |
| <a name="input_networks"></a> [networks](#input\_networks) | Map of networks to create | <pre>map(object({<br/>    name                                      = string<br/>    project_id                                = string<br/>    auto_create_subnetworks                   = bool<br/>    routing_mode                              = string<br/>    network_firewall_policy_enforcement_order = string<br/>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to deploy resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region for resources | `string` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of artifact registry repositories | <pre>map(object({<br/>    repository_id          = string<br/>    description            = string<br/>    cleanup_policy_dry_run = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_routers"></a> [routers](#input\_routers) | Map of compute routers with NAT configuration | <pre>map(object({<br/>    name       = string<br/>    network    = string<br/>    subnetwork = string<br/>    nat = object({<br/>      name                               = string<br/>      nat_ip_allocate_option             = string<br/>      source_subnetwork_ip_ranges_to_nat = string<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Map of service account configurations | <pre>map(object({<br/>    account_id      = string<br/>    display_name    = string<br/>    description     = string<br/>    allow_iam_roles = bool<br/>    roles           = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_snapshot_policies"></a> [snapshot\_policies](#input\_snapshot\_policies) | Map of snapshot policies | <pre>map(object({<br/>    retention_policy = object({<br/>      max_retention_days    = number<br/>      on_source_disk_delete = string<br/>    })<br/>    schedule = object({<br/>      daily_schedule = optional(object({<br/>        days_in_cycle = number<br/>        start_time    = string<br/>      }))<br/>      hourly_schedule = optional(object({<br/>        hours_in_cycle = number<br/>        start_time     = string<br/>      }))<br/>      weekly_schedule = optional(object({<br/>        day_of_weeks = list(object({<br/>          day        = string<br/>          start_time = string<br/>        }))<br/>      }))<br/>    })<br/>    snapshot_properties = object({<br/>      labels            = map(string)<br/>      storage_locations = list(string)<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_subnetworks"></a> [subnetworks](#input\_subnetworks) | Map of subnetworks to create | <pre>map(object({<br/>    name                       = string<br/>    project_id                 = string<br/>    region                     = string<br/>    network                    = string<br/>    ip_cidr_range              = string<br/>    private_ip_google_access   = bool<br/>    private_ipv6_google_access = string<br/>    purpose                    = string<br/>    stack_type                 = string # "IPV4_ONLY", "DUAL_STACK", or "IPV6_ONLY"<br/>    secondary_ip_ranges = optional(list(object({<br/>      range_name    = string<br/>      ip_cidr_range = string<br/>    })), [])<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_names"></a> [bucket\_names](#output\_bucket\_names) | Map of Storage Bucket names created |
| <a name="output_compute_addresses"></a> [compute\_addresses](#output\_compute\_addresses) | Map of Compute Address IPs |
| <a name="output_firewall_names"></a> [firewall\_names](#output\_firewall\_names) | Map of Firewall rule names created |
| <a name="output_repository_names"></a> [repository\_names](#output\_repository\_names) | Map of repository names created |
| <a name="output_router_names"></a> [router\_names](#output\_router\_names) | Map of Compute Router names created |
<!-- END_TF_DOCS -->