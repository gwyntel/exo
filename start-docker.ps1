param(
    [Parameter(Mandatory=$true)]
    [string]$TailscaleAuthKey,
    [Parameter(Mandatory=$true)]
    [string]$TailscaleApiKey
)

# Check if the image exists locally
if (-not (docker images -q exo:latest)) {
    Write-Host "Local exo image not found. Please run build-docker.ps1 first to build the image."
    exit 1
}

# Run the container with Tailscale networking
docker run `
    --rm `
    -it `
    --name exo-container `
    --hostname exo-docker `
    --privileged `
    --cap-add=NET_ADMIN `
    --cap-add=NET_RAW `
    -e "TS_AUTHKEY=$TailscaleAuthKey" `
    -e "TS_API_KEY=$TailscaleApiKey" `
    exo:latest

Write-Host "Docker container started successfully!"
