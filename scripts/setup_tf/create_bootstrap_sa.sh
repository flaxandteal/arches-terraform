#!/bin/bash

# Exit on error
set -e

# Path to the configuration file
CONFIG_FILE="config.env"
echo "Using configuration file: ${CONFIG_FILE}"

# Check if the config file exists
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "Error: Configuration file '${CONFIG_FILE}' not found."
  echo "Please create '${CONFIG_FILE}' with the following format:"
  echo "PROJECT_ID=your-project-id"
  echo "SA_NAME=terraform-bootstrap"
  echo "SA_DISPLAY_NAME=Terraform Bootstrap Service Account"
  echo "KEY_FILE=/path/to/terraform-bootstrap.json"
  exit 1
fi
echo "config file found"

# Source the configuration file
source "${CONFIG_FILE}"
echo "checking config file"

# Validate required variables
REQUIRED_VARS=("PROJECT_ID" "BOOTSTRAP_SA_NAME" "BOOTSTRAP_SA_DISPLAY_NAME" "BOOTSTRAP_KEY_FILE")
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo "Error: Required variable '${VAR}' is not set in '${CONFIG_FILE}'."
    exit 1
  fi
done

# Set the project
echo "Setting project to ${PROJECT_ID}..."
gcloud config set project "${PROJECT_ID}"

# Define roles to assign
ROLES=(
  "roles/iam.serviceAccountAdmin" # to create service accounts
  "roles/iam.serviceAccountKeyAdmin" # to create service account keys 
  "roles/storage.admin" # to create a storage bucket
  "roles/serviceusage.serviceUsageAdmin" # to enable APIs
  "roles/resourcemanager.projectIamAdmin" # to set IAM policies
)
#sji tidy!
#"roles/iam.serviceAccountKeyViewer" # to view service account keys - sji remove? not strictly needed
#"roles/iam.roleadmin" # to manage IAM roles  (Optional, but often used if custom roles are needed)
  # "roles/iam.serviceAccountUser" # to use the servexitice account
  # "roles/iam.serviceAccountTokenCreator" # to create tokens
  # "roles/iam.securityAdmin" # to manage IAM policies (Optional, but needed if the service account must set IAM policies on other resources)
  # "roles/iam.serviceAccountDelegator" # to delegate service account permissions
  # "roles/iam.serviceAccountViewer" # to view service accounts
  # "roles/iam.serviceAccountKeyViewer" # to view service account keys
  # "roles/iam.serviceAccountTokenCreator" # to create tokens
  # "roles/iam.serviceAccountAdmin" # to manage service accounts  
  # "roles/iam.serviceAccountKeyAdmin" # to manage service account keys
  # "roles/iam.serviceAccountUser" # to use the service account
  # "roles/iam.serviceAccountTokenCreator" # to create tokens sji maybe!
  # "roles/iam.serviceAccountDelegator" # to delegate service account permissions
  # "roles/iam.serviceAccountViewer" # to view service accounts

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
  echo "Error: gcloud CLI is not installed. Please install the Google Cloud SDK."
  exit 1
fi

# Create the service account
echo "Creating service account ${BOOTSTRAP_SA_NAME}..."
gcloud iam service-accounts create "${BOOTSTRAP_SA_NAME}" \
  --display-name="${BOOTSTRAP_SA_DISPLAY_NAME}" \
  --project="${PROJECT_ID}"

# Delay to ensure the service account is created before assigning roles
#without this the assign roles command fails
sleep 5

# Check if the service account was created successfully
if ! gcloud iam service-accounts list --project="${PROJECT_ID}" | grep -q "${BOOTSTRAP_SA_NAME}"; then
  echo "Error: Service account '${BOOTSTRAP_SA_NAME}' was not created successfully."
  exit 1
fi

# Assign roles to the service account
for ROLE in "${ROLES[@]}"; do
  echo "Assigning role ${ROLE} to service account..."
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${BOOTSTRAP_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="${ROLE}"
done

# Create and download the service account key
echo "Generating service account key..."
gcloud iam service-accounts keys create "${BOOTSTRAP_KEY_FILE}" \
  --iam-account="${BOOTSTRAP_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}"

# Set GOOGLE_APPLICATION_CREDENTIALS environment variable - todo remove?
echo "Setting GOOGLE_APPLICATION_CREDENTIALS to ${BOOTSTRAP_KEY_FILE}..."
export GOOGLE_APPLICATION_CREDENTIALS="${BOOTSTRAP_KEY_FILE}"

# Create required secrets
chmod +x ./add_github_secret.sh
./add_github_secret.sh ${BOOTSTRAP_SA_SECRET} ${BOOTSTRAP_KEY_FILE}

# Check if the secret was added successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to add the secret to GitHub."
  exit 1
fi

# Create required secrets
chmod +x ./add_github_secret.sh
./add_github_secret.sh GCP_PROJECT_ID ${PROJECT_ID}

# Check if the secret was added successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to add the secret to GitHub."
  exit 1
fi

# Instructions for Terraform - tweak sji
echo "Service account created and credentials set."
echo "To initialize Terraform for the 'dev' environment, run:"
echo "  cd environments/dev"
echo "  terraform init -backend-config=\"prefix=terraform/state/dev\""
echo "You can now run 'terraform apply' to deploy the infrastructure."
echo "The service account key is saved at: ${BOOTSTRAP_KEY_FILE}"