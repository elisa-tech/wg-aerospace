#!/bin/bash

# SPDX-License-Identifier: MIT

# Check if the script is running with root privileges
if [[ "$EUID" -eq 0 ]]; then
	echo "This script does not require running with 'sudo' or as root.  It does have commands in it which use sudo so there will be a password prompt."
	exit 1
fi

# Check if sudo works
if ! sudo -n true 2>/dev/null; then
	echo "You need sudo rights..."
	exit 1
fi

# Install Docker if missing
if ! command -v /usr/bin/docker &>/dev/null; then
	echo "Installing prerequisites ..."
	{
		sudo apt-get update &&
			sudo apt-get install -y docker.io iptables
	} || {
		echo "Failed to setup Docker prerequisites"
		exit 1
	}
else
	echo "Docker already installed..."
fi

# Install Tool Dependencies
echo "Installing prerequisites ..."
{
	sudo apt-get update &&
		sudo apt-get install -y make ca-certificates passwd curl
} || {
	echo "Failed to setup Demo prerequisites"
	exit 1
}

# Setup user permissions for using Docker
echo "Adding user to docker group ..."
sudo usermod -aG docker "${SUDO_USER:-$USER}" || {
	echo "Failed to configure user permissions"
	exit 1
}

sudo systemctl status docker &>/dev/null || sudo systemctl restart docker
sudo systemctl status docker | grep "Active"
