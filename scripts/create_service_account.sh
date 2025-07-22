# Creates a service account, assigns roles, and generates a key file.

set -e

# Input validation
if [ "$#" -lt 4 ]; then
  echo "Usage: $0 <PROJECT_ID> <SA_NAME> <SA_DISPLAY_NAME> <KEY_FILE> [ROLE1 ROLE2 ...]"
  exit 1
fi

PROJECT_ID="$1"
SA_NAME="$2"
SA_DISPLAY_NAME="$3"
KEY_FILE="$4"
shift 4
ROLES=("$@")

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
  echo "Error: gcloud CLI is not installed."
  exit 1
fi

# Set the project
echo "Setting project to ${PROJECT_ID}..."
gcloud config set project "${PROJECT_ID}"

# Create the service account
echo "Creating service account ${SA_NAME}..."
gcloud iam service-accounts create "${SA_NAME}" \
  --display-name="${SA_DISPLAY_NAME}" \
  --project="${PROJECT_ID}"

sleep 5  # Wait to avoid IAM propagation delay - without this the assign roles command fails

# Check if the service account was created
if ! gcloud iam service-accounts list --project="${PROJECT_ID}" | grep -q "${SA_NAME}"; then
  echo "Error: Service account '${SA_NAME}' was not created."
  exit 1
fi

# Assign roles
for ROLE in "${ROLES[@]}"; do
  echo "Assigning role ${ROLE} to service account..."
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="${ROLE}"
done

# Generate service account key
echo "Creating key file at ${KEY_FILE}..."
gcloud iam service-accounts keys create "${KEY_FILE}" \
  --iam-account="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}"

# Export the credentials path
echo "GOOGLE_APPLICATION_CREDENTIALS=${KEY_FILE}"