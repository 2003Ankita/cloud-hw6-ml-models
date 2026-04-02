#!/bin/bash

set -e

PROJECT_ID=$(gcloud config get-value project)
VM_NAME="hw6-vm"

echo "Using project: $PROJECT_ID"

ZONES=("us-east1-b" "us-east1-c" "us-east4-a" "us-west1-b")

for ZONE in "${ZONES[@]}"; do
  echo "Trying zone: $ZONE"

  if gcloud compute instances create $VM_NAME \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --metadata-from-file startup-script=startup.sh; then

    echo "VM created successfully in $ZONE"
    exit 0
  else
    echo "Failed in $ZONE, trying next..."
  fi
done

echo "All zones failed. Try again later."
exit 1