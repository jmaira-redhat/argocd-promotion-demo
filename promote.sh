#!/bin/bash

TARGET_ENV=$1
NEW_TAG=$2
REGISTRY="registry.access.redhat.com/ubi9/ubi-minimal"

if [ -z "$TARGET_ENV" ] || [ -z "$NEW_TAG" ]; then
    echo "Usage: ./promote.sh [dev|test|prod] [tag]"
    exit 1
fi

FILE="overlays/${TARGET_ENV}/kustomization.yaml"

if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found!"
    exit 1
fi

echo "Promoting ${TARGET_ENV} to version ${NEW_TAG}..."

# Check if we are on macOS or Linux to handle 'sed -i' correctly
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i "" "s/newTag: \".*\"/newTag: \"${NEW_TAG}\"/" $FILE
  sed -i "" "s|value: \"${REGISTRY}:.*\"|value: \"${REGISTRY}:${NEW_TAG}\"|" $FILE
else
  sed -i "s/newTag: \".*\"/newTag: \"${NEW_TAG}\"/" $FILE
  sed -i "s|value: \"${REGISTRY}:.*\"|value: \"${REGISTRY}:${NEW_TAG}\"|" $FILE
fi

echo "Done! Check your $FILE now."