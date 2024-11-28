### Using Docker

exo is available as a multi-architecture Docker image that supports both ARM64 and x86_64 platforms.

#### Pull and run the pre-built image:

```sh
docker pull exo:latest
docker run -p 52415:52415 exo:latest
```

#### Build from source:

If you want to build the Docker image yourself:

```sh
# Clone the repository
git clone https://github.com/exo-explore/exo.git
cd exo

# For Windows:
.\build-docker.ps1

# For Linux/macOS:
./build-docker.sh
```

The Docker image will automatically detect your system architecture and use the appropriate version. The WebUI and API will be available at http://localhost:52415.

Note: When running in Docker, the automatic device discovery features will be limited to the host network. For multi-device setups, it's recommended to use the native installation method.
