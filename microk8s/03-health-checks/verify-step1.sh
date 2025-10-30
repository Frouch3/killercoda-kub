#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod liveness-http existe
if ! microk8s kubectl get pod liveness-http >/dev/null 2>&1; then
  echo "❌ Le pod 'liveness-http' n'existe pas."
  exit 1
fi

# Vérifier que le pod liveness-crash existe
if ! microk8s kubectl get pod liveness-crash >/dev/null 2>&1; then
  echo "❌ Le pod 'liveness-crash' n'existe pas."
  exit 1
fi

# Vérifier que liveness-http a une liveness probe configurée
if ! microk8s kubectl get pod liveness-http -o yaml | grep -q "livenessProbe"; then
  echo "❌ Le pod 'liveness-http' n'a pas de livenessProbe configurée"
  exit 1
fi

echo "✅ Liveness Probes configurées correctement!"
