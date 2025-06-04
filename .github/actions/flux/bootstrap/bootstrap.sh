#!/bin/bash
set -e

# Path to the .env config - sji todo move the file to the root of the repo
CONFIG_FILE="${CONFIG_FILE:-.github/actions/flux/bootstrap/config.env}"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "ERROR: Config file not found at $CONFIG_FILE"
  exit 1
fi

# Load environment variables
set -o allexport
source "$CONFIG_FILE"
set +o allexport

# Optional: Check for required variables
: "${FLUX_GITHUB_OWNER:?Missing FLUX_GITHUB_OWNER}"
: "${FLUX_GITHUB_REPOSITORY:?Missing FLUX_GITHUB_REPOSITORY}"
: "${FLUX_GITHUB_BRANCH:?Missing FLUX_GITHUB_BRANCH}"
: "${FLUX_GITHUB_PATH:?Missing FLUX_GITHUB_PATH}"

# Check if Flux is already installed
if kubectl get ns flux-system >/dev/null 2>&1; then
  echo "Flux already installed. Skipping bootstrap."
else
  echo "Bootstrapping Flux..."
  flux bootstrap github \
    --owner="$FLUX_GITHUB_OWNER" \
    --repository="$FLUX_GITHUB_REPOSITORY" \
    --branch="$FLUX_GITHUB_BRANCH" \
    --path="$FLUX_GITHUB_PATH" \
    ${FLUX_GITHUB_PERSONAL:+--personal}
fi
