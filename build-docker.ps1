# Enable Docker BuildKit
$env:DOCKER_BUILDKIT=1

# Create a new builder instance if it doesn't exist
docker buildx create --name exo-builder --use

# Build multi-platform image
docker buildx build `
  --platform linux/amd64,linux/arm64 `
  --tag exo:latest `
  --file Dockerfile `
  --push `
  .

Write-Host "Multi-architecture Docker image built successfully!"
