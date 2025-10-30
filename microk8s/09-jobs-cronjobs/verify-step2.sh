#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le Job parallel-worker existe ou a existé
if ! microk8s kubectl get job parallel-worker >/dev/null 2>&1; then
  echo "❌ Le Job 'parallel-worker' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl apply -f parallel-job.yaml"
  exit 1
fi

# Vérifier que le Job a les bonnes configurations
COMPLETIONS=$(microk8s kubectl get job parallel-worker -o jsonpath='{.spec.completions}')
PARALLELISM=$(microk8s kubectl get job parallel-worker -o jsonpath='{.spec.parallelism}')

if [ "$COMPLETIONS" != "5" ]; then
  echo "❌ Le Job 'parallel-worker' doit avoir completions: 5"
  echo "💡 Valeur actuelle: $COMPLETIONS"
  exit 1
fi

if [ "$PARALLELISM" != "2" ]; then
  echo "❌ Le Job 'parallel-worker' doit avoir parallelism: 2"
  echo "💡 Valeur actuelle: $PARALLELISM"
  exit 1
fi

# Vérifier que le Job est terminé ou en cours
SUCCEEDED=$(microk8s kubectl get job parallel-worker -o jsonpath='{.status.succeeded}' 2>/dev/null)

if [ -z "$SUCCEEDED" ] || [ "$SUCCEEDED" -lt 1 ]; then
  ACTIVE=$(microk8s kubectl get job parallel-worker -o jsonpath='{.status.active}' 2>/dev/null)
  if [ -n "$ACTIVE" ] && [ "$ACTIVE" -gt 0 ]; then
    echo "⏳ Le Job 'parallel-worker' est en cours d'exécution. Attendez qu'il progresse..."
    exit 1
  fi
fi

echo "✅ Job parallèle configuré correctement!"
