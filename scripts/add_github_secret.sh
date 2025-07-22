#!/bin/bash

# Usage check
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <secret_name> <file_path_or_raw_value>"
  echo "Examples:"
  echo "  $0 BOOTSTRAP_KEY_FILE /home/user/terraform-bootstrap.json"
  echo "  $0 ENVIRONMENT production"
  exit 1
fi

SECRET_NAME="$1"
VALUE_INPUT="$2"

# Determine value: from file or raw string
if [ -f "$VALUE_INPUT" ]; then
  echo "📄 Reading secret value from file: $VALUE_INPUT"
  SECRET_VALUE=$(<"$VALUE_INPUT")
else
  echo "📝 Using raw string as secret value"
  SECRET_VALUE="$VALUE_INPUT"
fi

# Get current GitHub repo
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)

if [ -z "$REPO" ]; then
  echo "❌ Could not determine the current repository. Make sure you're in a valid GitHub repo directory."
  exit 1
fi

echo "📦 Using repository: $REPO"

# Set the secret
echo "$SECRET_VALUE" | gh secret set "$SECRET_NAME" --repo "$REPO"

# Confirmation
if [ $? -eq 0 ]; then
  echo "✅ Secret '$SECRET_NAME' successfully added to $REPO"
else
  echo "❌ Failed to add secret"
  exit 1
fi
