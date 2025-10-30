#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le secret database-credentials existe
if ! microk8s kubectl get secret database-credentials >/dev/null 2>&1; then
  echo "❌ Le Secret 'database-credentials' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl create secret generic database-credentials --from-literal=..."
  exit 1
fi

# Vérifier que le secret ssh-key existe
if ! microk8s kubectl get secret ssh-key >/dev/null 2>&1; then
  echo "❌ Le Secret 'ssh-key' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl apply -f ssh-secret.yaml"
  exit 1
fi

# Vérifier que database-credentials contient les bonnes clés
if ! microk8s kubectl get secret database-credentials -o jsonpath='{.data.DB_PASSWORD}' | grep -q .; then
  echo "❌ Le Secret 'database-credentials' doit contenir la clé DB_PASSWORD"
  exit 1
fi

echo "✅ Secrets créés correctement!"
