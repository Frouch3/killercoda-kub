#!/bin/bash
microk8s kubectl get configmap symfony-config >/dev/null 2>&1 && echo "✅ ConfigMap créée!" || exit 1

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
