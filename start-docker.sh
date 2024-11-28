#!/bin/bash

# Check if the image exists locally
if [[ "$(docker images -q exo:latest 2> /dev/null)" == "" ]]; then
    echo "Local exo image not found. Please run build-docker.sh first to build the image."
    exit 1
fi

# Ensure that TS_API_KEY and TS_AUTHKEY environment variables are set
if [[ -z "$TS_API_KEY" || -z "$TS_AUTHKEY" ]]; then
    echo "Please set the TS_API_KEY and TS_AUTHKEY environment variables before running this script."
    exit 1
fi

# Run the container with the necessary environment variables
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
    -e TS_API_KEY="$TS_API_KEY" \
    -e TS_AUTHKEY="$TS_AUTHKEY" \
    exo:latest

echo "Docker container started successfully!"
