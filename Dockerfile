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

# Create startup script
RUN echo '#!/bin/bash\n\
tailscaled --state=mem: &\n\
tailscale up --authkey="$TS_AUTHKEY" --hostname="exo-docker" --accept-routes\n\
exec python exo/main.py\n\
' > /start.sh && chmod +x /start.sh

# Expose the port used by exo
EXPOSE 52415

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Command to run the application
ENTRYPOINT ["/start.sh"]
