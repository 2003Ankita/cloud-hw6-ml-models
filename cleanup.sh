#!/bin/bash

ZONE="us-east1-b"
VM_NAME="hw6-vm"

echo "Deleting VM..."
gcloud compute instances delete $VM_NAME --zone=$ZONE --quiet || echo "VM not found"

echo "Stopping Cloud SQL..."
gcloud sql instances patch hw5-db --activation-policy=NEVER

echo "Printing bucket contents..."
gsutil ls gs://pagerank-bu-ap178152/

echo "Cleanup completed."