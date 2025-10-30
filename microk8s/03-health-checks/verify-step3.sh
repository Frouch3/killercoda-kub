#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod slow-startup existe
if ! microk8s kubectl get pod slow-startup >/dev/null 2>&1; then
  echo "❌ Le pod 'slow-startup' n'existe pas."
  exit 1
fi

# Vérifier que slow-startup a une startup probe
if ! microk8s kubectl get pod slow-startup -o yaml | grep -q "startupProbe"; then
  echo "❌ Le pod 'slow-startup' n'a pas de startupProbe"
  exit 1
fi

# Vérifier que le pod no-startup-probe existe
if ! microk8s kubectl get pod no-startup-probe >/dev/null 2>&1; then
  echo "❌ Le pod 'no-startup-probe' n'existe pas."
  exit 1
fi

echo "✅ Startup Probes configurées et testées!"
