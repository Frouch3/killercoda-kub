#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le deployment existe
if ! microk8s kubectl get deployment nginx-deployment >/dev/null 2>&1; then
  echo "❌ Le deployment 'nginx-deployment' n'existe pas"
  exit 1
fi

# Vérifier que le deployment a au moins 2 révisions dans l'historique
REVISION_COUNT=$(microk8s kubectl rollout history deployment/nginx-deployment 2>/dev/null | grep -c "^[0-9]")

if [ "$REVISION_COUNT" -lt "2" ]; then
  echo "❌ Le deployment devrait avoir au moins 2 révisions (actuellement: $REVISION_COUNT)"
  echo "💡 Effectuez une mise à jour de l'image avec:"
  echo "   microk8s kubectl set image deployment/nginx-deployment nginx=nginxdemos/hello:plain-text"
  exit 1
fi

# Vérifier que tous les pods sont prêts
DESIRED=$(microk8s kubectl get deployment nginx-deployment -o jsonpath='{.spec.replicas}')
READY=$(microk8s kubectl get deployment nginx-deployment -o jsonpath='{.status.readyReplicas}')

if [ "$READY" != "$DESIRED" ]; then
  echo "⚠️  Tous les pods ne sont pas encore prêts ($READY/$DESIRED)"
  echo "    Attendez quelques secondes que tous les pods soient à jour"
  exit 1
fi

echo "✅ Rolling Update effectué avec succès! ($REVISION_COUNT révisions dans l'historique)"
