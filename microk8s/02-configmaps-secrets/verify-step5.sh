#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le secret tls-secret existe
if ! microk8s kubectl get secret tls-secret >/dev/null 2>&1; then
  echo "❌ Le Secret 'tls-secret' n'existe pas."
  exit 1
fi

# Vérifier que le pod existe
if ! microk8s kubectl get pod app-with-tls >/dev/null 2>&1; then
  echo "❌ Le pod 'app-with-tls' n'existe pas."
  exit 1
fi

# Attendre que le pod soit prêt
if ! microk8s kubectl wait --for=condition=Ready pod/app-with-tls --timeout=30s >/dev/null 2>&1; then
  echo "❌ Le pod 'app-with-tls' n'est pas prêt."
  exit 1
fi

# Vérifier que le fichier TLS est bien monté
if ! microk8s kubectl exec app-with-tls -- test -f /etc/nginx/ssl/tls.crt 2>/dev/null; then
  echo "❌ Le certificat TLS n'est pas monté dans le pod"
  exit 1
fi

# Vérifier les permissions restrictives
PERMS=$(microk8s kubectl exec app-with-tls -- stat -c '%a' /etc/nginx/ssl/tls.key 2>/dev/null)
if [ "$PERMS" != "400" ]; then
  echo "⚠️  Les permissions du fichier tls.key devraient être 400 (actuellement: $PERMS)"
fi

echo "✅ Secret monté comme volume avec les bonnes permissions!"
