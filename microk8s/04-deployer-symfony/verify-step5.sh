#!/bin/bash
microk8s kubectl get ingress symfony-ingress >/dev/null 2>&1 && echo "✅ Ingress créé!" || exit 1

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
