#!/bin/bash
if ! microk8s kubectl get pvc data-pvc >/dev/null 2>&1; then

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
  echo "❌ Le PVC 'data-pvc' n'existe pas"
  exit 1
fi
STATUS=$(microk8s kubectl get pvc data-pvc -o jsonpath='{.status.phase}')
if [ "$STATUS" != "Bound" ]; then
  echo "⚠️  Le PVC n'est pas encore Bound (actuellement: $STATUS)"
  exit 1
fi
echo "✅ PVC créé et lié!"
