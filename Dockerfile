# Use Python 3.12 slim as base (required by exo)
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies and Tailscale
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    iptables \
    iproute2 \
    kmod \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker cache
COPY setup.py .
COPY README.md .

# Install Python dependencies
RUN pip install --no-cache-dir -e .

# Install formatting dependencies
RUN pip install --no-cache-dir ".[formatting]"

# Copy the rest of the application
COPY . .

# Create startup script that ensures TUN device exists
RUN echo '#!/bin/bash\n\
# Load the TUN module\n\
modprobe tun || true\n\
\n\
# Create the TUN device\n\
mkdir -p /dev/net\n\
if [ ! -c /dev/net/tun ]; then\n\
    mknod /dev/net/tun c 10 200\n\
fi\n\
chmod 600 /dev/net/tun\n\
\n\
# Start tailscaled in the background\n\
tailscaled --state=mem: &\n\
TAILSCALED_PID=$!\n\
\n\
# Wait for tailscaled to be ready\n\
sleep 5\n\
\n\
# Attempt to bring up tailscale\n\
tailscale up --authkey="$TS_AUTHKEY" --hostname="exo-docker" --accept-routes\n\
\n\
# Start the Python application\n\
python exo/main.py\n\
\n\
# Cleanup\n\
kill $TAILSCALED_PID\n\
' > /start.sh && chmod +x /start.sh

# Expose the port used by exo
EXPOSE 52415

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Command to run the application
ENTRYPOINT ["/start.sh"]
