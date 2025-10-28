#!/bin/bash

# Vérifier que le service existe
if ! microk8s kubectl get svc nginx-service >/dev/null 2>&1; then
  echo "❌ Le service 'nginx-service' n'existe pas."
  echo "💡 Exécutez : microk8s kubectl apply -f nginx-service.yaml"
  exit 1
fi

# Vérifier le type du service
SERVICE_TYPE=$(microk8s kubectl get svc nginx-service -o jsonpath='{.spec.type}')
if [ "$SERVICE_TYPE" != "ClusterIP" ]; then
  echo "❌ Le service doit être de type ClusterIP (actuellement: $SERVICE_TYPE)"
  exit 1
fi

# Vérifier que le service a des endpoints
ENDPOINTS=$(microk8s kubectl get endpoints nginx-service -o jsonpath='{.subsets[0].addresses[*].ip}')
if [ -z "$ENDPOINTS" ]; then
  echo "❌ Le service n'a pas d'endpoints (les pods ne sont pas sélectionnés)"
  echo "💡 Vérifiez que le selector du Service correspond aux labels des pods"
  exit 1
fi

# Compter le nombre d'endpoints
ENDPOINT_COUNT=$(echo "$ENDPOINTS" | wc -w)
if [ "$ENDPOINT_COUNT" != "2" ]; then
  echo "⚠️  Le service devrait avoir 2 endpoints (actuellement: $ENDPOINT_COUNT)"
  echo "    Cela peut arriver si les pods ne sont pas encore prêts"
fi

echo "✅ Service créé correctement avec des endpoints valides!"
