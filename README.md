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
4. You must have the following installed locally to bootstrap this:
        GitHub CLI (gh --version to check)
        GCP CLI (gcloud version to check)
Authenticate to both.
        gh auth login
        gcloud auth login
Set the project
        gcloud config set project PROJECT_ID
Check the current project
        gcloud config get-value project 
5. Enable googleapis for the new GCP project
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

