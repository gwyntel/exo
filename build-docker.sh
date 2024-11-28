#!/bin/bash

# Enable Docker BuildKit
export DOCKER_BUILDKIT=1

# Create a new builder instance if it doesn't exist
docker buildx create --name exo-builder --use || true

# Build multi-platform image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag exo:latest \
  --file Dockerfile \
  --push \
  .

echo "Multi-architecture Docker image built successfully!"
