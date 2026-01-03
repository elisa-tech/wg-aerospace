#!/bin/bash

# SPDX-License-Identifier: MIT

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
    sudo apt-get update &&
        sudo apt-get install -y docker.io make ca-certificates passwd curl wslu iptables
} || {
    echo "Failed to setup Docker prerequisites"
    exit 1
}

# Setup user permissions. Ensure the actual user (not root) is used when the script is run with sudo initially to install docker
sudo usermod -aG docker "${SUDO_USER:-$USER}" || {
   echo "Failed to configure user permissions"
   exit 1
}
