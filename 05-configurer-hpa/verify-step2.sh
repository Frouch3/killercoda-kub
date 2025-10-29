#!/bin/bash
microk8s kubectl get deployment php-app >/dev/null 2>&1 && echo "✅ Application déployée!" || exit 1

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
