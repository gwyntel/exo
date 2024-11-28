# Use Python 3.12 slim as base (required by exo)
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
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

# Expose the port used by exo
EXPOSE 52415

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Command to run the application
ENTRYPOINT ["exo"]
