#!/bin/bash

# Enable Docker BuildKit
export DOCKER_BUILDKIT=1

# Build local image
docker build \
  --tag exo:latest \
  --file Dockerfile \
  .

echo "Docker image built successfully!"
