#!/bin/bash

# Prevent running multiple times
if [ -f /var/log/startup_already_done ]; then
    echo "Startup script already ran once. Skipping."
    exit 0
fi

echo "Starting VM setup..."

# Update packages
apt-get update

# Install Python and pip
apt-get install -y python3 python3-pip git

# Install required Python libraries
pip3 install pandas scikit-learn psycopg2-binary google-cloud-storage

# Create working directory
mkdir -p /opt/hw6
cd /opt/hw6

# (We will later clone your repo and run model here)

echo "Setup complete."

# Lock file
touch /var/log/startup_already_done
