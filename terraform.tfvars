common_labels = {
  project     = "coral-hed"
  environment = "production"
}

gke_version = "1.32.3-gke.1927009"

project_id = "coral-hed"
location   = "europe-west2"
region     = "europe-west2"
format     = "DOCKER"
mode       = "STANDARD_REPOSITORY"

repositories = {
  arches = {
    repository_id          = "arches"
    description            = "Core Arches images for Coral (see *static* for deployable)"
    cleanup_policy_dry_run = true
  },
  arches_prd = {
    repository_id          = "arches-prd"
    description            = "Core Arches images for Coral (see *static* for deployable)"
    cleanup_policy_dry_run = true
  },
  archesdata_prd = {
    repository_id          = "archesdata-prd"
    description            = "Core Arches images for Coral (see *static* for deployable)"
    cleanup_policy_dry_run = true
  }
}

addresses = {

}

networks = {
  coral_network_stg = {
    name                                      = "coral-network"
    project_id                                = "coral-hed"
    auto_create_subnetworks                   = false
    routing_mode                              = "REGIONAL"
    network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  },
  coral_network_prd = {
    name                                      = "coral-network-prd"
    project_id                                = "coral-hed"
    auto_create_subnetworks                   = false
    routing_mode                              = "REGIONAL"
    network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  }
}

subnetworks = {
  subnet_stg = {
    name                       = "coral-subnetwork"
    project_id                 = "coral-hed"
    region                     = "europe-west2"
    ip_cidr_range              = "10.2.0.0/16"
    private_ip_google_access   = true
    private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
    purpose                    = "PRIVATE"
    stack_type                 = "IPV4_ONLY"
    network                    = "coral_network_stg" # Use the key from the 'networks' map

    secondary_ip_ranges = [
      {
        range_name    = "services-range"
        ip_cidr_range = "192.168.0.0/20"
      },
      {
        range_name    = "pod-ranges"
        ip_cidr_range = "192.168.64.0/20"
      },
      {
        range_name    = "gke-coral-cluster-pods-f3c8dd1b"
        ip_cidr_range = "10.196.0.0/14"
      },
      {
        range_name    = "gke-coral-cluster-services-f3c8dd1b"
        ip_cidr_range = "10.200.0.0/20"
      }
    ]
  }
  subnet_prd = {
    name                       = "coral-subnetwork-prd"
    project_id                 = "coral-hed"
    region                     = "europe-west2"
    ip_cidr_range              = "10.2.0.0/16"
    private_ip_google_access   = true
    private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
    purpose                    = "PRIVATE"
    stack_type                 = "IPV4_ONLY"
    network                    = "coral_network_prd" # Use the key from the 'networks' map

    secondary_ip_ranges = [
      {
        range_name    = "services-range"
        ip_cidr_range = "192.168.0.0/20"
      },
      {
        range_name    = "pod-ranges"
        ip_cidr_range = "192.168.64.0/20"
      },
      {
        range_name    = "gke-coral-cluster-pods-f3c8dd1b"
        ip_cidr_range = "10.196.0.0/14"
      },
      {
        range_name    = "gke-coral-cluster-services-f3c8dd1b"
        ip_cidr_range = "10.200.0.0/20"
      }
    ]
  }
}

firewalls = {
  letsencrpt_egress = {
    name               = "letsencrpt-egress"
    network            = "https://www.googleapis.com/compute/v1/projects/coral-hed/global/networks/coral-network"
    direction          = "EGRESS"
    priority           = 1000
    destination_ranges = ["0.0.0.0/0"]
    source_ranges      = []
    allow = [{
      ports    = ["443"]
      protocol = "tcp"
    }]
    description = "Encrypt egress"
    target_tags = []
  },
  k8s_fw = {
    name               = "k8s-fw"
    description        = "Kubernetes traffic"
    network            = "https://www.googleapis.com/compute/v1/projects/coral-hed/global/networks/coral-network"
    direction          = "INGRESS"
    priority           = 1000
    destination_ranges = ["34.89.106.198"]
    source_ranges      = ["0.0.0.0/0"]
    target_tags        = ["gke-k8s-coral-stg-4b674dca-node"]
    allow = [{
      ports    = ["80", "443", "15021"]
      protocol = "tcp"
    }]
  },
  coral_prd = {
    name          = "allow-ingress-coral-prd"
    network       = "https://www.googleapis.com/compute/v1/projects/coral-hed/global/networks/coral-network-prd"
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["172.16.0.0/28"]
    target_tags   = ["gke-k8s-coral-prd-np-tf-8r35wt"]
    allow = [{
      protocol = "tcp"
      ports    = ["10250", "443", "15017", "8080", "15000"]
    }]
    description        = "Allow ingress for Coral production GKE cluster"
    destination_ranges = []
  },
  coral_stg = {
    name          = "allow-ingress-coral-stg"
    network       = "https://www.googleapis.com/compute/v1/projects/coral-hed/global/networks/coral-network"
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["172.16.0.0/28"]
    target_tags   = ["gke-k8s-coral-stg-np-tf-cejctx"]
    allow = [{
      protocol = "tcp"
      ports    = ["10250", "443", "15017", "8080", "15000"]
    }]
    description        = "Allow ingress for Coral staging GKE cluster"
    destination_ranges = []
  },
}

buckets = {
  data_store_prd = {
    name                        = "crl-hed-data-store-prd-eu-west-2-flax"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "enforced"
    uniform_bucket_level_access = true
    cors                        = []
    encryption                  = null
    logging                     = null
  },
  data_store_uat_prd = {
    name                        = "crl-hed-data-store-uat-eu-west-2-prd"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = true
    cors = [{
      max_age_seconds = 3600
      method          = ["GET"]
      origin          = ["https://coral-her.flaxandteal.co.uk"]
      response_header = ["Content-Type"]
    }]
    encryption = {
      default_kms_key_name = "projects/coral-hed/locations/europe-west2/keyRings/data-store-keyring-uat-prd/cryptoKeys/data-store-key-uat-prd"
    }
    logging = {
      log_bucket        = "log-store-eu-west-2"
      log_object_prefix = "crl-hed-data-store-uat-eu-west-2-prd"
    }
  },
  data_store_uat = {
    name                        = "crl-hed-data-store-uat-eu-west-2"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "enforced"
    uniform_bucket_level_access = true
    cors = [{
      max_age_seconds = 3600
      method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      origin          = ["https://coral-uat.flaxandteal.co.uk"]
      response_header = ["*"]
    }]
    encryption = {
      default_kms_key_name = "projects/coral-hed/locations/europe-west2/keyRings/data-store-keyring-uat/cryptoKeys/data-store-key-uat"
    }
    logging = {
      log_bucket        = "log-store-eu-west-2"
      log_object_prefix = "crl-hed-data-store-uat-eu-west-2"
    }
  },
  log_store_prd = {
    name                        = "crl-hed-log-store-eu-west-2-prd"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = true
    encryption                  = null
    cors                        = []
    logging                     = null
  },
  log_store = {
    name                        = "crl-hed-log-store-eu-west-2"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = true
    encryption                  = null
    cors                        = []
    logging                     = null
  },
  artifacts_us = {
    name                        = "artifacts-crl-hed-appspot-com"
    location                    = "US"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = false
    encryption                  = null
    cors                        = []
    logging                     = null
  },
  artifacts_eu = {
    name                        = "eu-artifacts-crl-hed-appspot-com"
    location                    = "EU"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = false
    encryption                  = null
    cors                        = []
    logging                     = null
  }
}

service_accounts = {
  "arches_k8s_prd" = {
    account_id      = "coral-arches-k8s-coral-prd"
    display_name    = "Coral Production GKE Service Account"
    description     = "Service account for GKE cluster in production"
    allow_iam_roles = true
    roles = [
      "container.clusterAdmin",
      "compute.viewer",
      "logging.logWriter",
      "monitoring.metricWriter",
      "artifactregistry.reader",
      "container.nodeServiceAccount",
      "iam.serviceAccountTokenCreator",
      "stackdriver.resourceMetadata.writer",
      "storage.objectViewer"
    ]
  }
  "arches_k8s_stg" = {
    account_id      = "coral-arches-k8s-coral-stg"
    display_name    = "Coral Staging GKE Service Account"
    description     = "Service account for GKE cluster in staging"
    allow_iam_roles = true
    roles = [
      "artifactregistry.reader",
      "container.nodeServiceAccount",
      "logging.logWriter",
      "monitoring.metricWriter",
      "stackdriver.resourceMetadata.writer",
      "storage.objectViewer",
      "container.clusterAdmin",
      "compute.viewer"
    ]
  }
  "arches_uat_prd" = {
    account_id      = "coral-arches-uat-prd"
    display_name    = "Coral Production Arches Service Account"
    description     = "Service account for Coral production Arches"
    allow_iam_roles = false
    roles           = ["storage.objectAdmin"]
  }
  "arches_uat" = {
    account_id      = "coral-arches-uat"
    display_name    = "Coral UAT Arches Service Account"
    description     = "Service account for Coral UAT Arches"
    allow_iam_roles = false
    roles           = ["storage.objectAdmin", "cloudkms.cryptoKeyEncrypterDecrypter"]
  }
  "ci_prd" = {
    account_id      = "coral-ci-prd"
    display_name    = "Coral Production CI Service Account"
    description     = "Service account for CI in production"
    allow_iam_roles = false
    roles           = ["compute.admin", "storage.admin", "container.admin"]
  }
  "ci" = {
    account_id      = "coral-ci"
    display_name    = "Coral CI Service Account"
    description     = "Service account for CI"
    allow_iam_roles = true
    roles = [
      "artifactregistry.admin",
      "cloudbuild.builds.builder"
    ]
  }
  "flux_prd" = {
    account_id      = "coral-flux-prd"
    display_name    = "Coral Production Flux Service Account"
    description     = "Service account for Flux in production"
    allow_iam_roles = false
    roles           = ["container.developer", "cloudkms.cryptoKeyEncrypterDecrypter"]
  }
  "gl_ci_prd" = {
    account_id      = "coral-gl-ci-prd"
    display_name    = "Coral Production Data Operations Service Account"
    description     = "Service account for data operations in production"
    allow_iam_roles = false
    roles           = ["bigquery.dataEditor", "storage.objectAdmin"]
  }
  "github-actions" = {
    account_id      = "github-actions"
    display_name    = "Github Actions Service Account"
    description     = "Service account for github actions"
    allow_iam_roles = true
    roles           = ["artifactregistry.writer"]
  }
}

routers = {
  prd = {
    name       = "coral-network-router-prd"
    network    = "https://www.googleapis.com/compute/v1/projects/coral-hed/global/networks/coral-network-prd"
    subnetwork = "https://www.googleapis.com/compute/v1/projects/coral-hed/regions/europe-west2/subnetworks/coral-subnetwork-prd"
    nat = {
      name                               = "coral-network-router-prd-Nat"
      nat_ip_allocate_option             = "AUTO_ONLY"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    }
  },
  stg = {
    name       = "coral-network-router"
    network    = "https://www.googleapis.com/compute/v1/projects/coral-hed/global/networks/coral-network"
    subnetwork = "https://www.googleapis.com/compute/v1/projects/coral-hed/regions/europe-west2/subnetworks/coral-subnetwork"
    nat = {
      name                               = "coral-network-router-Nat"
      nat_ip_allocate_option             = "AUTO_ONLY"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    }
  }
}

kms_key_rings = {
  data_store_prd = {
    name       = "data-store-keyring-uat-prd"
    infix_name = "infix1"
    location   = "europe-west2"
    project_id = "coral-hed"
    crypto_keys = {
      "data-store-key-uat-prd" = {
        name                = "data-store-key-uat-prd"
        service_account_key = "arches_uat_prd"
      }
      "flux-key-uat-prd" = {
        name                = "flux-key-uat-prd"
        service_account_key = "flux_prd"
      }
    }
    labels = {
      env = "prd"
      app = "data-store"
    }
  },
  data_store_uat = {
    name       = "data-store-keyring-uat"
    infix_name = "infix1"
    location   = "europe-west2"
    project_id = "coral-hed"
    crypto_keys = {
      "data-store-key-uat" = {
        name                = "data-store-key-uat"
        service_account_key = "arches_uat"
      }
    }
    labels = {
      env = "uat"
      app = "data-store"
    }
  }
}

clusters = {
  prd = {
    name                     = "k8s-coral-prd"
    location                 = "europe-west2-a"
    network                  = "projects/coral-hed/global/networks/coral-network-prd"
    subnetwork               = "projects/coral-hed/regions/europe-west2/subnetworks/coral-subnetwork-prd"
    initial_node_count       = 0
    remove_default_node_pool = true
    node_config = {
      disk_size_gb    = 50
      disk_type       = "pd-balanced"
      image_type      = "COS_CONTAINERD"
      logging_variant = "DEFAULT"
      machine_type    = "e2-standard-4"
      metadata        = { disable-legacy-endpoints = "true" }
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append"
      ]
      service_account = "coral-arches-k8s-coral-prd@coral-hed.iam.gserviceaccount.com"
      shielded_instance_config = {
        enable_integrity_monitoring = true
      }
      workload_metadata_config = { mode = "GKE_METADATA" }
      labels = {
        TF_used_by  = "k8s-coral-prd"
        TF_used_for = "gke"
      }
      tags = ["gke-k8s-coral-prd-np-tf-cejctx"]
    }
    ip_allocation_policy = {
      cluster_secondary_range_name  = "pod-ranges"
      services_secondary_range_name = "services-range"
      # stack_type                    = "IPV4"
      # pod_cidr_overprovision_config = { disabled = false }
      # additional_pod_ranges_config = {
      #   pod_range_names = ["gke-coral-cluster-pods-f3c8dd1b"]
      # }
    }
    addons_config = {
      #dns_cache_config                      = { enabled = true }
      #gce_persistent_disk_csi_driver_config = { enabled = true }
      horizontal_pod_autoscaling = { disabled = false }
      http_load_balancing        = { disabled = false }
      network_policy_config      = { disabled = false }
    }
    #cluster_autoscaling       = { autoscaling_profile = "BALANCED" }
    #cluster_telemetry         = { type = "ENABLED" }
    #database_encryption       = { state = "DECRYPTED", key_name = "" }
    default_max_pods_per_node = 8
    default_snat_status       = { disabled = false }
    description               = "Generated by Terraform"
    #enable_shielded_nodes     = true
    logging_config = {
      enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
    }
    maintenance_policy = {
      recurring_window = {
        end_time   = "2025-05-11T07:00:00Z"
        recurrence = "FREQ=WEEKLY;BYDAY=FR"
        start_time = "2025-05-10T19:00:00Z"
      }
    }
    #master_auth = {
    #  client_certificate_config = { issue_client_certificate = false }
    #}
    master_authorized_networks_config = {
      cidr_blocks = [
        { cidr_block = "31.51.55.181/32", display_name = "F&T VPN" },
        { cidr_block = "80.177.36.11/32", display_name = "PTW1" },
        { cidr_block = "31.94.66.14/32", display_name = "Cloudshell" },
        { cidr_block = "35.214.39.113/32", display_name = "F&T VPN" }
      ]
    }
    monitoring_config = {
      advanced_datapath_observability_config = {
        enable_metrics = false
        enable_relay   = false
      }
      enable_components = ["SYSTEM_COMPONENTS"]
    }
    network_policy = {
      enabled = true
      #provider = "PROVIDER_UNSPECIFIED"
    }
    networking_mode = "VPC_NATIVE"

    #node_pool_defaults = {
    #  node_config_defaults = {
    #    logging_variant = "DEFAULT"
    #  }
    #}
    notification_config = {
      pubsub = { enabled = false }
    }
    #pod_security_policy_config = { enabled = false }
    private_cluster_config = {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = "172.16.0.0/28"
      master_global_access_config = {
        enabled = false
      }
    }
    protect_config = {
      workload_config = { audit_mode = "DISABLED" }
    }
    release_channel = { channel = "REGULAR" }
    security_posture_config = {
      mode               = "BASIC"
      vulnerability_mode = "VULNERABILITY_DISABLED"
    }
    #service_external_ips_config = { enabled = false }
    vertical_pod_autoscaling = { enabled = false }
    workload_identity_config = { workload_pool = "coral-hed.svc.id.goog" }
    node_pools = {
      prd = {
        name               = "prod"
        machine_type       = "e2-standard-4" #"e2-standard-8"
        disk_size_gb       = 50
        disk_type          = "pd-balanced"
        image_type         = "COS_CONTAINERD"
        auto_repair        = true
        auto_upgrade       = true
        min_node_count     = 1
        max_node_count     = 8
        initial_node_count = 1 #7
        max_pods_per_node  = 64
        location_policy    = "ANY"
        max_surge          = 1
        max_unavailable    = 0
        preemptible        = false
        spot               = false
        labels = {
          "TF_used_by"  = "k8s-coral-prd"
          "TF_used_for" = "gke"
        }
        network_config = {
          enable_private_nodes = true
          pod_range            = "gke-coral-cluster-pods-f3c8dd1b"
        }
        tags        = ["gke-node"]
        metadata    = { "disable-legacy-endpoints" = "true" }
        node_taints = []
        gpu_type    = null
        shielded_instance_config = {
          enable_secure_boot          = false
          enable_integrity_monitoring = true
        }
        workload_metadata_config = { mode = "GKE_METADATA" }
      }
    }
  } #,
  # stg = {
  #   name                     = "k8s-coral-stg"
  #   location                 = "europe-west2-a"
  #   network                  = "projects/coral-hed/global/networks/coral-network"
  #   subnetwork               = "projects/coral-hed/regions/europe-west2/subnetworks/coral-subnetwork"
  #   initial_node_count       = 1
  #   remove_default_node_pool = true
  #   node_config = {
  #     disk_size_gb    = 50
  #     disk_type       = "pd-standard"
  #     image_type      = "COS_CONTAINERD"
  #     logging_variant = "DEFAULT"
  #     machine_type    = "e2-standard-4"
  #     metadata = {
  #       disable-legacy-endpoints = "true"
  #     }
  #     oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  #     service_account = "coral-arches-k8s-coral-stg@coral-hed.iam.gserviceaccount.com"
  #     shielded_instance_config = {
  #       enable_integrity_monitoring = true
  #     }
  #     workload_metadata_config = {
  #       mode = "GKE_METADATA"
  #     }
  #     labels = {
  #       TF_used_by  = "k8s-coral-stg"
  #       TF_used_for = "gke"
  #     }
  #     tags = ["gke-node"]
  #   }
  #   ip_allocation_policy = {
  #     cluster_secondary_range_name  = "pod-ranges"
  #     services_secondary_range_name = "services-range"
  #     stack_type                    = "IPV4"
  #     pod_cidr_overprovision_config = {
  #       disabled = false
  #     }
  #     additional_pod_ranges_config = {
  #       pod_range_names = []
  #     }
  #   }
  #   addons_config = {
  #     dns_cache_config = {
  #       enabled = true
  #     }
  #     gce_persistent_disk_csi_driver_config = {
  #       enabled = true
  #     }
  #     horizontal_pod_autoscaling = {
  #       disabled = false
  #     }
  #     http_load_balancing = {
  #       disabled = false
  #     }
  #     network_policy_config = {
  #       disabled = true
  #     }
  #   }
  #   cluster_autoscaling = {
  #     autoscaling_profile = "BALANCED"
  #   }
  #   cluster_telemetry = {
  #     type = "ENABLED"
  #   }
  #   database_encryption = {
  #     state    = "DECRYPTED"
  #     key_name = ""
  #   }
  #   default_max_pods_per_node = 8
  #   default_snat_status = {
  #     disabled = false
  #   }
  #   description           = "Generated by Terraform"
  #   enable_shielded_nodes = true
  #   logging_config = {
  #     enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  #   }
  #   maintenance_policy = {
  #     recurring_window = {
  #       end_time   = "2025-05-11T07:00:00Z"
  #       recurrence = "FREQ=WEEKLY;BYDAY=FR"
  #       start_time = "2025-05-10T19:00:00Z"
  #     }
  #   }
  #   master_auth = {
  #     client_certificate_config = {
  #       issue_client_certificate = false
  #     }
  #   }
  #   master_authorized_networks_config = {
  #     cidr_blocks = [
  #       {
  #         cidr_block   = "31.94.20.141/32"
  #         display_name = "PTW"
  #       },
  #       {
  #         cidr_block   = "80.177.36.11/32"
  #         display_name = "SMH"
  #       },
  #       {
  #         cidr_block   = "35.214.39.113/32"
  #         display_name = "F&T VPN"
  #       },
  #       {
  #         cidr_block   = "31.94.39.13/32"
  #         display_name = "F&T Office"
  #       }
  #     ]
  #   }
  #   monitoring_config = {
  #     advanced_datapath_observability_config = {
  #       enable_metrics = false
  #       enable_relay   = false
  #     }
  #     enable_components = ["SYSTEM_COMPONENTS"]
  #   }
  #   network_policy = {
  #     enabled  = false
  #     provider = "PROVIDER_UNSPECIFIED"
  #   }
  #   networking_mode = "VPC_NATIVE"
  #   node_pool_defaults = {
  #     node_config_defaults = {
  #       logging_variant = "DEFAULT"
  #     }
  #   }
  #   notification_config = {
  #     pubsub = {
  #       enabled = false
  #     }
  #   }
  #   pod_security_policy_config = {
  #     enabled = false
  #   }
  #   private_cluster_config = {
  #     enable_private_nodes   = true
  #     master_ipv4_cidr_block = "172.16.0.0/28"
  #     master_global_access_config = {
  #       enabled = false
  #     }
  #   }
  #   protect_config = {
  #     workload_config = {
  #       audit_mode = "DISABLED"
  #     }
  #   }
  #   release_channel = {
  #     channel = "REGULAR"
  #   }
  #   security_posture_config = {
  #     mode               = "BASIC"
  #     vulnerability_mode = "VULNERABILITY_DISABLED"
  #   }
  #   service_external_ips_config = {
  #     enabled = false
  #   }
  #   vertical_pod_autoscaling = {
  #     enabled = false
  #   }
  #   workload_identity_config = {
  #     workload_pool = "coral-hed.svc.id.goog"
  #   }
  #   node_pools = {
  #     stg = {
  #       machine_type       = "e2-standard-4"
  #       disk_size_gb       = 50
  #       disk_type          = "pd-standard"
  #       image_type         = "COS_CONTAINERD"
  #       auto_repair        = true
  #       auto_upgrade       = true
  #       min_node_count     = 1
  #       max_node_count     = 3
  #       initial_node_count = 1
  #       max_pods_per_node  = 8
  #       location_policy    = "ANY"
  #       max_surge          = 1
  #       max_unavailable    = 0
  #       preemptible        = true
  #       spot               = false
  #       labels = {
  #         "TF_used_by"  = "k8s-coral-stg"
  #         "TF_used_for" = "gke"
  #       }
  #       tags = ["gke-k8s-coral-stg-np-tf-cejctx"]
  #       metadata = {
  #         "disable-legacy-endpoints" = "true"
  #       }
  #       node_taints = []
  #       gpu_type    = null
  #       shielded_instance_config = {
  #         enable_secure_boot          = false
  #         enable_integrity_monitoring = true
  #       }
  #       workload_metadata_config = {
  #         mode = "GKE_METADATA"
  #       }
  #     }
  #   }
  # }

  # network_config {
  #   enable_private_nodes = true
  #   pod_ipv4_cidr_block  = "192.168.64.0/20"
  #   pod_range            = "pod-ranges"
  # }
}

snapshot_policies = {
  coral-postgres = {
    retention_policy = {
      max_retention_days    = 14
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    schedule = {
      daily_schedule = {
        days_in_cycle = 1
        start_time    = "19:00"
      }
    }
    snapshot_properties = {
      labels = {
        purpose = "db"
      }
      storage_locations = ["europe-west2"]
    }
  }
}