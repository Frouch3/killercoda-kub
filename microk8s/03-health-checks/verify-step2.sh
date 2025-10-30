#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le deployment existe
if ! microk8s kubectl get deployment readiness-demo >/dev/null 2>&1; then
  echo "❌ Le deployment 'readiness-demo' n'existe pas."
  exit 1
fi

# Vérifier que le pod readiness-toggle existe
if ! microk8s kubectl get pod readiness-toggle >/dev/null 2>&1; then
  echo "❌ Le pod 'readiness-toggle' n'existe pas."
  exit 1
fi

# Vérifier que readiness-demo a une readiness probe
if ! microk8s kubectl get deployment readiness-demo -o yaml | grep -q "readinessProbe"; then
  echo "❌ Le deployment 'readiness-demo' n'a pas de readinessProbe"
  exit 1
fi

echo "✅ Readiness Probes configurées correctement!"
