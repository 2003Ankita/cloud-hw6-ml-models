#!/bin/bash

# Run only once
if [ -f /var/log/startup_already_done ]; then
    echo "Startup already ran. Skipping."
    exit 0
fi

echo "Starting VM setup..."

# Update and install packages
apt-get update
apt-get install -y python3 python3-pip git wget

# Install Python libraries
pip3 install pandas scikit-learn psycopg2-binary google-cloud-storage

# Create working directory
mkdir -p /opt/hw6
cd /opt/hw6

# Clone your repo
git clone https://github.com/2003Ankita/cloud-hw6-ml-models.git
cd cloud-hw6-ml-models

# ---- Start Cloud SQL Proxy ----
echo "Starting Cloud SQL Proxy..."
wget https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.11.0/cloud-sql-proxy.linux.amd64 -O cloud-sql-proxy
chmod +x cloud-sql-proxy

./cloud-sql-proxy sustained-flow-485619-g3:us-central1:hw5-db --port 5432 &
sleep 10

# ---- Run Models ----
echo "Running Model 1..."
python3 model_ip_country.py

echo "Running Model 2..."
python3 model_income.py

# ---- Upload Outputs ----
echo "Uploading outputs to bucket..."
gsutil cp ip_country_predictions.csv gs://pagerank-bu-ap178152/
gsutil cp income_predictions.csv gs://pagerank-bu-ap178152/

echo "All tasks completed successfully!"

# Prevent rerun
touch /var/log/startup_already_done