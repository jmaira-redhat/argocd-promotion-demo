#!/bin/bash

# Usage: ./promote.sh [target_env] [new_tag]
# Example: ./promote.sh test 9.5

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

# 1. Update the newTag line
sed -i "s/newTag: \".*\"/newTag: \"${NEW_TAG}\"/" $FILE

# 2. Update the IMAGE_INFO patch value line
sed -i "s|value: \"${REGISTRY}:.*\"|value: \"${REGISTRY}:${NEW_TAG}\"|" $FILE

echo "Done! Review changes and commit."