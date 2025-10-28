#!/bin/bash

# Vérifier que le deployment existe
if ! microk8s kubectl get deployment web-app >/dev/null 2>&1; then
  echo "❌ Le deployment 'web-app' n'existe pas"
  echo "💡 Exécutez : microk8s kubectl apply -f app-deployment.yaml"
  exit 1
fi

# Vérifier que le service existe
if ! microk8s kubectl get svc web-service >/dev/null 2>&1; then
  echo "❌ Le service 'web-service' n'existe pas"
  echo "💡 Exécutez : microk8s kubectl apply -f app-service.yaml"
  exit 1
fi

# Vérifier que les pods sont Running
RUNNING_COUNT=$(microk8s kubectl get pods -l app=web --no-headers 2>/dev/null | grep -c Running)
if [ "$RUNNING_COUNT" -lt "1" ]; then
  echo "⚠️  Les pods ne sont pas encore Running"
  echo "    Attendez quelques secondes"
  exit 1
fi

echo "✅ Application déployée avec succès!"
