#!/bin/bash
# Navigate to the directory of the script
cd "$(dirname "$0")"

# Generate SSH keys if they don't exist
if [ ! -f id_rsa ]; then
  echo "SSH keys (id_rsa/id_rsa.pub) not found. Generating new key pair..."
  ssh-keygen -t rsa -b 2048 -f id_rsa -N ""
  chmod 600 id_rsa
  chmod 644 id_rsa.pub
else
  echo "Using existing SSH keys in infra/ directory."
fi

# Detect container runtime and start compose
if command -v docker &> /dev/null; then
  echo "Starting infrastructure using Docker..."
  docker compose up -d --build
elif command -v podman &> /dev/null; then
  if command -v podman-compose &> /dev/null; then
    echo "Starting infrastructure using Podman Compose..."
    podman-compose up -d --build
  else
    echo "Starting infrastructure using Podman..."
    podman compose up -d --build
  fi
else
  echo "Error: Neither Docker nor Podman is installed. Please install a container engine."
  exit 1
fi
