#!/bin/bash

# Check if the image exists locally
if [[ "$(docker images -q exo:latest 2> /dev/null)" == "" ]]; then
    echo "Local exo image not found. Please run build-docker.sh first to build the image."
    exit 1
fi

# Run the container with UDP networking capabilities and tskey-auth token
docker run \
    --rm \
    -it \
    --name exo-container \
    --hostname exo-docker \
    --privileged \
    --cap-add=NET_ADMIN \
    --cap-add=NET_BROADCAST \
    --cap-add=NET_RAW \
    --network host \
    exo:latest --discovery-module=udp --tskey-auth=tskey-auth-kxGANdMRez11CNTRL-GmyEnAePLhfbdWWJviJwgfKYU9xtfA99W

echo "Docker container started successfully!"
