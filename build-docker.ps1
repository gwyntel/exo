# Enable Docker BuildKit
$env:DOCKER_BUILDKIT=1

# Build local image
docker build `
  --tag exo:latest `
  --file Dockerfile `
  .

Write-Host "Docker image built successfully!"
