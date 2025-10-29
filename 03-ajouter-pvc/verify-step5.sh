#!/bin/bash
if ! microk8s kubectl get deployment app-with-storage >/dev/null 2>&1; then

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
  echo "❌ Le deployment 'app-with-storage' n'existe pas"
  exit 1
fi
READY=$(microk8s kubectl get deployment app-with-storage -o jsonpath='{.status.readyReplicas}')
if [ "$READY" != "1" ]; then
  echo "⚠️  Le deployment n'est pas encore prêt"
  exit 1
fi
echo "✅ Deployment avec PVC fonctionnel!"
