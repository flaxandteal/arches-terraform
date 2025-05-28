#!/bin/bash
set -e

read -r input
PROJECT=$(echo "$input" | jq -r '.project')
LOCATION=$(echo "$input" | jq -r '.location')
NAME=$(echo "$input" | jq -r '.name')

if gcloud kms keyrings describe "$NAME" --location="$LOCATION" --project="$PROJECT" >/dev/null 2>&1; then
  echo '{"exists": true}'
else
  echo '{"exists": false}'
fi
