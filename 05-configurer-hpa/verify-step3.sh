#!/bin/bash
microk8s kubectl get hpa php-app >/dev/null 2>&1 && echo "✅ HPA configuré!" || exit 1

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
