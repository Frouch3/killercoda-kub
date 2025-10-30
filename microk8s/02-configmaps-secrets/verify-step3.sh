#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod existe
if ! microk8s kubectl get pod app-with-config >/dev/null 2>&1; then
  echo "❌ Le pod 'app-with-config' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl apply -f app-with-config.yaml"
  exit 1
fi

# Attendre que le pod soit prêt
if ! microk8s kubectl wait --for=condition=Ready pod/app-with-config --timeout=30s >/dev/null 2>&1; then
  echo "❌ Le pod 'app-with-config' n'est pas prêt."
  echo "💡 Vérifiez avec : microk8s kubectl describe pod app-with-config"
  exit 1
fi

# Vérifier que les variables d'environnement sont injectées
ENV_VARS=$(microk8s kubectl exec app-with-config -- env 2>/dev/null)

if ! echo "$ENV_VARS" | grep -q "APP_NAME"; then
  echo "❌ La variable APP_NAME n'est pas présente dans le pod"
  exit 1
fi

if ! echo "$ENV_VARS" | grep -q "DB_PASSWORD"; then
  echo "❌ La variable DB_PASSWORD (depuis Secret) n'est pas présente"
  exit 1
fi

echo "✅ Pod créé avec les variables d'environnement correctement injectées!"
