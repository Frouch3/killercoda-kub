#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le configmap nginx-config existe
if ! microk8s kubectl get configmap nginx-config >/dev/null 2>&1; then
  echo "❌ Le ConfigMap 'nginx-config' n'existe pas."
  exit 1
fi

# Vérifier que le pod existe
if ! microk8s kubectl get pod nginx-with-volume >/dev/null 2>&1; then
  echo "❌ Le pod 'nginx-with-volume' n'existe pas."
  exit 1
fi

# Attendre que le pod soit prêt
if ! microk8s kubectl wait --for=condition=Ready pod/nginx-with-volume --timeout=30s >/dev/null 2>&1; then
  echo "❌ Le pod 'nginx-with-volume' n'est pas prêt."
  exit 1
fi

# Vérifier que le fichier est bien monté
if ! microk8s kubectl exec nginx-with-volume -- test -f /etc/nginx/nginx.conf 2>/dev/null; then
  echo "❌ Le fichier /etc/nginx/nginx.conf n'est pas monté dans le pod"
  exit 1
fi

echo "✅ ConfigMap monté comme volume correctement!"
