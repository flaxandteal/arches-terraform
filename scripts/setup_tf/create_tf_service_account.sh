#!/bin/bash

# Exit on error
set -e

# Path to the configuration file
CONFIG_FILE="scripts/setup_tf/config.env"
echo "Using configuration file: ${CONFIG_FILE}"

# Check if the config file exists
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "Error: Configuration file '${CONFIG_FILE}' not found."
  echo "Please create '${CONFIG_FILE}' with the following format:"
  echo "PROJECT_ID=your-project-id"
  echo "TF_SA_NAME=terraformsa"
  echo "TF_SA_DISPLAY_NAME=Terraform Service Account"
  echo "TF_KEY_FILE=/path/to/terraform.json"
  exit 1
fi
echo "config file found"

# Source the configuration file
source "${CONFIG_FILE}"
echo "checking config file"

# Validate required variables
REQUIRED_VARS=("PROJECT_ID" "TF_SA_NAME" "TF_SA_DISPLAY_NAME" "TF_KEY_FILE")
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo "Error: Required variable '${VAR}' is not set in '${CONFIG_FILE}'."
    exit 1
  fi
done

# Define roles to assign - starting with least privs! sji todo
ROLES=(
  "roles/compute.admin"
  "roles/iam.serviceAccountUser"
  "roles/storage.admin"
  "roles/iam.serviceAccountKeyAdmin"
  "roles/resourcemanager.projectIamAdmin"
  "roles/editor" # sji todo - custom role here - this is too broad
  "roles/cloudkms.admin"
  "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  "roles/container.clusterAdmin"
  "roles/container.admin"
)

# Authenticate with GCP (assumes CI provides credentials or user is authenticated)
echo "Authenticating with GCP..."
if [[ -n "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
  gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
else
  echo "Warning: GOOGLE_APPLICATION_CREDENTIALS not set. Assuming default credentials."
fi

#Set the project
gcloud config set project "$PROJECT_ID"

#Create the service account
echo "Creating service account ${TF_SA_NAME}..."
gcloud iam service-accounts create "${TF_SA_NAME}" \
  --display-name="${TF_SA_DISPLAY_NAME}" \
  --project="${PROJECT_ID}" \
  --description="Service account for Terraform"

# Delay to ensure the service account is created before assigning roles
#without this the assign roles command fails
sleep 10

# Check if the service account was created successfully
if ! gcloud iam service-accounts list --project="${PROJECT_ID}" | grep -q "${TF_SA_NAME}"; then
  echo "Error: Service account '${TF_SA_NAME}' was not created successfully."
  exit 1
fi

# Assign roles to the service account
for ROLE in "${ROLES[@]}"; do
  echo "Assigning role ${ROLE} to service account..."
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${TF_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="${ROLE}"
done

# Create and download the service account key
echo "Generating service account key..."
gcloud iam service-accounts keys create "${TF_KEY_FILE}" \
  --iam-account="${TF_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}"

# Set GOOGLE_APPLICATION_CREDENTIALS environment variable
echo "Setting GOOGLE_APPLICATION_CREDENTIALS to ${TF_KEY_FILE}..."
export GOOGLE_APPLICATION_CREDENTIALS="${TF_KEY_FILE}"

# Create required secrets
chmod +x scripts/add_github_secret.sh
scripts/add_github_secret.sh ${TF_SA_SECRET} ${TF_KEY_FILE}

# Check if the secret was added successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to add the secret to GitHub."
  exit 1
fi
