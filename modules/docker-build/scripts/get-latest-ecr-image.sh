#!/bin/bash

# Lecture de l'entrée JSON
read -r INPUT
REPO=$(echo "$INPUT" | jq -r '.repository // empty')
REGION=$(echo "$INPUT" | jq -r '.region // empty')

if [[ -z "$REPO" || -z "$REGION" ]]; then
  echo '{"image_uri": ""}'
  exit 0
fi

# Check if repo exists
if ! aws ecr describe-repositories --repository-names "$REPO" --region "$REGION" >/dev/null 2>&1; then
  echo 'no{"image_uri": ""}'
  exit 0
fi

# Get latest image tag
IMAGE=$(aws ecr describe-images \
  --repository-name "$REPO" \
  --region "$REGION" \
  --query 'reverse(sort_by(imageDetails, &imagePushedAt))[?imageTags]|[0].imageTags[0]' \
  --output text 2>/dev/null || echo "")

if [ -z "$IMAGE" ] || [ "$IMAGE" == "None" ]; then
  echo '{"image_uri": ""}'
  exit 0
fi

# Get full image URI
URI=$(aws ecr describe-repositories \
  --repository-names "$REPO" \
  --region "$REGION" \
  --query 'repositories[0].repositoryUri' \
  --output text)

echo "{\"image_uri\": \"${URI}:${IMAGE}\"}"
