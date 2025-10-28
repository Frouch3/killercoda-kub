#!/bin/bash
if ! microk8s kubectl get pod reader-pod >/dev/null 2>&1; then
  echo "❌ Le pod 'reader-pod' n'existe pas"
  exit 1
fi
if microk8s kubectl logs reader-pod 2>/dev/null | grep -q "Data persisted"; then
  echo "✅ Les données ont bien persisté!"
  exit 0
fi
echo "⚠️  Attendez que le pod soit prêt"
exit 1
