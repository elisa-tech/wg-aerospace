#!/bin/bash

# Check if the script is running with root privileges
if [[ "$EUID" -eq 0 ]]; then
  echo "This script does not require running with 'sudo'."
  exit 1
fi

# Check if sudo works
if ! sudo -n true 2> /dev/null; then
    echo "You need sudo rights..."
    exit 1
fi

echo "Installing prerequisites ..."
{
    sudo rm /etc/apt/sources.list.d/docker.list -f #remove prior Docker apt repository
    sudo apt-get update &&
        sudo apt-get install -y make ca-certificates passwd curl wslu iptables
} || {
    echo "Failed to setup Docker prerequisites"
    exit 1
}

if ! command -v /usr/bin/docker &> /dev/null; then
    # Get Docker pkgs
    {
        wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/containerd.io_1.7.25-1_amd64.deb
        wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-buildx-plugin_0.21.1-1~ubuntu.24.04~noble_amd64.deb
        wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce-cli_28.0.1-1~ubuntu.24.04~noble_amd64.deb
        wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce_28.0.1-1~ubuntu.24.04~noble_amd64.deb
        wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-compose-plugin_2.33.1-1~ubuntu.24.04~noble_amd64.deb    
    } || {
        echo "Failed to download docker pkgs"
        exit 1
    }

    # Install Docker packages
    {
        # If something goes wrong, here's the command to undo these installs
        # sudo dpkg -r containerd.io docker-buildx-plugin docker-ce docker-ce-cli docker-compose-plugin
        sudo dpkg -i ./containerd* \
          ./docker-ce_* \
          ./docker-ce-cli_* \
          ./docker-buildx-plugin_* \
          ./docker-compose-plugin_*
        rm docker-* containerd* -f
    } || {
        echo "Failed to install Docker packages"
        exit 1
    }

    # Setup user permissions. Ensure the actual user (not root) is used when the script is run with sudo initially to install docker
    sudo usermod -aG docker "${SUDO_USER:-$USER}" || {
        echo "Failed to configure user permissions"
        exit 1
    }
fi
