#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le configmap app-config existe
if ! microk8s kubectl get configmap app-config >/dev/null 2>&1; then
  echo "❌ Le ConfigMap 'app-config' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl create configmap app-config --from-literal=..."
  exit 1
fi

# Vérifier que le configmap database-config existe
if ! microk8s kubectl get configmap database-config >/dev/null 2>&1; then
  echo "❌ Le ConfigMap 'database-config' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl apply -f database-config.yaml"
  exit 1
fi

# Vérifier que app-config contient les bonnes clés
KEYS=$(microk8s kubectl get configmap app-config -o jsonpath='{.data}' | grep -o '"[^"]*":' | tr -d '":' | sort)
EXPECTED="API_URL APP_ENV APP_NAME LOG_LEVEL"

if ! echo "$KEYS" | grep -q "APP_NAME"; then
  echo "❌ Le ConfigMap 'app-config' doit contenir la clé APP_NAME"
  exit 1
fi

echo "✅ ConfigMaps créés correctement!"
