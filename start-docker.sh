#!/bin/bash

# Check if the image exists locally
if [[ "$(docker images -q exo:latest 2> /dev/null)" == "" ]]; then
    echo "Local exo image not found. Please run build-docker.sh first to build the image."
    exit 1
fi

# Run the container with interactive mode and host networking
docker run \
    --rm \
    -it \
    --network host \
    --name exo-container \
    exo:latest

echo "Docker container started successfully!"
