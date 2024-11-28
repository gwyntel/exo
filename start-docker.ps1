# Check if the image exists locally
if (-not (docker images -q exo:latest)) {
    Write-Host "Local exo image not found. Please run build-docker.ps1 first to build the image."
    exit 1
}

# Run the container with interactive mode
docker run `
    --rm `
    -it `
    --name exo-container `
    exo:latest

Write-Host "Docker container started successfully!"
