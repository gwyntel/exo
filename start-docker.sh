#!/bin/bash

# Check if Tailscale auth key is provided
if [ -z "$1" ]; then
    echo "Error: Tailscale authentication key is required"
    echo "Usage: $0 <tailscale-auth-key>"
    exit 1
fi

TAILSCALE_AUTHKEY="$1"

# Check if the image exists locally
if [[ "$(docker images -q exo:latest 2> /dev/null)" == "" ]]; then
    echo "Local exo image not found. Please run build-docker.sh first to build the image."
    exit 1
fi

# Run the container with Tailscale networking
docker run \
    --rm \
    -it \
    --name exo-container \
    --hostname exo-docker \
    --privileged \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    -e "TS_AUTHKEY=$TAILSCALE_AUTHKEY" \
    exo:latest

echo "Docker container started successfully!"
