#!/bin/bash

# Run only once
if [ -f /var/log/startup_already_done ]; then
    echo "Startup already ran. Skipping."
    exit 0
fi

echo "Starting setup..."

# Install packages
apt-get update
apt-get install -y python3 python3-pip git

# Install Python libraries
pip3 install pandas scikit-learn psycopg2-binary google-cloud-storage

# Create working directory
mkdir -p /opt/hw6
cd /opt/hw6

# Clone repo
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

# Run models
python3 model_ip_country.py
python3 model_income.py

# Upload outputs to bucket
gsutil cp ip_country_predictions.csv gs://pagerank-bu-ap178152/
gsutil cp income_predictions.csv gs://pagerank-bu-ap178152/

echo "All tasks completed."

# Lock file
touch /var/log/startup_already_done