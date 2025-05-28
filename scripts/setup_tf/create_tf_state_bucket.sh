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
  echo "TF_BUCKET_NAME=state-store"
  echo "PROJECT_LOCATION=us-central1"
  exit 1
fi
echo "config file found"

# Source the configuration file
source "${CONFIG_FILE}"
echo "checking config file"

# Validate required variables
REQUIRED_VARS=("PROJECT_ID" "PROJECT_LOCATION" "TF_BUCKET_NAME" )
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo "Error: Required variable '${VAR}' is not set in '${CONFIG_FILE}'."
    exit 1
  fi
done

# Authenticate with GCP (assumes CI provides credentials)
echo "Authenticating with GCP..."
if [[ -n "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
  gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
else
  echo "Warning: GOOGLE_APPLICATION_CREDENTIALS not set. Assuming default credentials."
fi

# Set the project
gcloud config set project "$PROJECT_ID" #sji twice - tidy!

# Check if Cloud Storage API is enabled
echo "Enabling Cloud Storage API if not already enabled..."
gcloud services enable storage.googleapis.com --project="$PROJECT_ID"

# Check if bucket exists
if gsutil ls "gs://${TF_BUCKET_NAME}" >/dev/null 2>&1; then
    echo "Bucket gs://${TF_BUCKET_NAME} already exists. Skipping creation."
else
  echo "Creating bucket gs://${TF_BUCKET_NAME}..."
  gsutil mb -p "$PROJECT_ID" -l "${PROJECT_LOCATION}" -b on "gs://${TF_BUCKET_NAME}"
fi

# Enable versioning
echo "Enabling versioning on bucket..."
gsutil versioning set on "gs://${TF_BUCKET_NAME}"

# Set lifecycle rule (optional: keep last 10 versions)
echo "Configuring lifecycle rules..."
cat <<EOF > lifecycle.json
{
  "rule": [
    {
      "action": { "type": "Delete" },
      "condition": { "numNewerVersions": 10 }
    }
  ]
}
EOF
gsutil lifecycle set lifecycle.json "gs://${TF_BUCKET_NAME}"
rm lifecycle.json

# # Set IAM permissions
# echo "Configuring IAM permissions..."
# gsutil iam ch "user:$ADMIN_EMAIL:admin" "gs://${BUCKET_NAME}"
# if [[ -n "$DEVELOPER_EMAIL" ]]; then
#   gsutil iam ch "user:$DEVELOPER_EMAIL:objectCreator,objectViewer" "gs://$BUCKET_NAME"
# fi

echo "Bucket gs://${TF_BUCKET_NAME} is ready for Terraform state."