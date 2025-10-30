#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod backend existe et est Running
if ! microk8s kubectl get pod backend >/dev/null 2>&1; then
  echo "❌ Le pod 'backend' n'existe pas."
  echo "💡 Créez-le avec le fichier backend.yaml"
  exit 1
fi

BACKEND_STATUS=$(microk8s kubectl get pod backend -o jsonpath='{.status.phase}')
if [ "$BACKEND_STATUS" != "Running" ]; then
  echo "❌ Le pod 'backend' n'est pas Running (status: $BACKEND_STATUS)"
  exit 1
fi

# Vérifier que le service backend-service existe
if ! microk8s kubectl get service backend-service >/dev/null 2>&1; then
  echo "❌ Le service 'backend-service' n'existe pas."
  echo "💡 Créez-le avec le fichier backend.yaml"
  exit 1
fi

# Vérifier que le service a des endpoints
ENDPOINTS=$(microk8s kubectl get endpoints backend-service -o jsonpath='{.subsets[*].addresses[*].ip}')
if [ -z "$ENDPOINTS" ]; then
  echo "❌ Le service 'backend-service' n'a pas d'endpoints"
  echo "💡 Vérifiez que le selector du service matche les labels du pod backend"
  exit 1
fi

# Vérifier que le pod frontend existe
if ! microk8s kubectl get pod frontend >/dev/null 2>&1; then
  echo "❌ Le pod 'frontend' n'existe pas."
  echo "💡 Créez-le avec le fichier frontend.yaml"
  exit 1
fi

FRONTEND_STATUS=$(microk8s kubectl get pod frontend -o jsonpath='{.status.phase}')
if [ "$FRONTEND_STATUS" != "Running" ]; then
  echo "❌ Le pod 'frontend' n'est pas Running (status: $FRONTEND_STATUS)"
  exit 1
fi

# Tester la résolution DNS depuis frontend
if ! microk8s kubectl exec frontend -- nslookup backend-service >/dev/null 2>&1; then
  echo "❌ La résolution DNS de 'backend-service' échoue depuis frontend"
  echo "💡 Vérifiez CoreDNS et la configuration réseau"
  exit 1
fi

echo "✅ Communication réseau et DNS fonctionnent correctement!"
