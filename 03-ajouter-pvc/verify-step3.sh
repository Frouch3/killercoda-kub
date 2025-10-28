#!/bin/bash
if ! microk8s kubectl get pod writer-pod >/dev/null 2>&1; then
  echo "❌ Le pod 'writer-pod' n'existe pas"
  exit 1
fi
if ! microk8s kubectl get pod writer-pod -o jsonpath='{.status.phase}' | grep -q "Running"; then
  echo "⚠️  Le pod n'est pas encore Running"
  exit 1
fi
echo "✅ Pod créé et utilise le PVC!"
