#!/bin/bash

set -e  # stop on error

PROJECT_ID=$(gcloud config get-value project)
ZONE="us-east1-b"
VM_NAME="hw6-vm"

echo "Using project: $PROJECT_ID"

# Create VM with startup script
gcloud compute instances create $VM_NAME \
    --zone=$ZONE \
    --machine-type=e2-micro \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata-from-file startup-script=startup.sh

echo "VM created successfully."