#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier qu'au moins un des pods de démonstration existe
PODS_EXIST=false

if microk8s kubectl get pod memory-leak-demo >/dev/null 2>&1; then
  PODS_EXIST=true
fi

if microk8s kubectl get pod db-connection-demo >/dev/null 2>&1; then
  PODS_EXIST=true
fi

if microk8s kubectl get pod postgres-sim >/dev/null 2>&1; then
  PODS_EXIST=true
fi

if [ "$PODS_EXIST" = false ]; then
  echo "❌ Aucun pod de démonstration n'a été créé."
  exit 1
fi

echo "✅ Scénarios de défaillance testés!"
