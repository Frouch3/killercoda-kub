#!/bin/bash
microk8s kubectl get job symfony-migrations -o jsonpath='{.status.succeeded}' | grep -q "1" && echo "✅ Job complété!" || exit 1

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
