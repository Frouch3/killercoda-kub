#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod pending-app existe
if ! microk8s kubectl get pod pending-app >/dev/null 2>&1; then
  echo "❌ Le pod 'pending-app' n'existe pas."
  echo "💡 Créez-le avec le fichier pending-pod.yaml corrigé"
  exit 1
fi

# Vérifier que le pod est Running (pas Pending)
STATUS=$(microk8s kubectl get pod pending-app -o jsonpath='{.status.phase}')
if [ "$STATUS" = "Pending" ]; then
  echo "❌ Le pod 'pending-app' est toujours Pending"
  echo "💡 Réduisez les requests de ressources (CPU et RAM)"
  exit 1
fi

if [ "$STATUS" != "Running" ]; then
  echo "❌ Le pod 'pending-app' n'est pas Running (status: $STATUS)"
  exit 1
fi

# Vérifier que les requests sont raisonnables
CPU_REQ=$(microk8s kubectl get pod pending-app -o jsonpath='{.spec.containers[0].resources.requests.cpu}')
MEM_REQ=$(microk8s kubectl get pod pending-app -o jsonpath='{.spec.containers[0].resources.requests.memory}')

if [ -z "$CPU_REQ" ] || [ -z "$MEM_REQ" ]; then
  echo "⚠️  Le pod n'a pas de requests définies. Ajoutez-les pour les bonnes pratiques."
else
  echo "✅ Pod pending-app est Running avec des requests raisonnables!"
fi
