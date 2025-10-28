#!/bin/bash

# Vérifier que le deployment a au moins 2 révisions dans l'historique
REVISION_COUNT=$(microk8s kubectl rollout history deployment/nginx-deployment --no-headers 2>/dev/null | wc -l)

if [ "$REVISION_COUNT" -lt "2" ]; then
  echo "❌ Le deployment devrait avoir au moins 2 révisions (actuellement: $REVISION_COUNT)"
  echo "💡 Effectuez une mise à jour de l'image avec:"
  echo "   microk8s kubectl set image deployment/nginx-deployment nginx=nginx:1.26-alpine"
  exit 1
fi

# Vérifier que le rollout est complété
if ! microk8s kubectl rollout status deployment/nginx-deployment --timeout=10s > /dev/null 2>&1; then
  echo "⚠️  Le rollout n'est pas encore terminé"
  echo "    Attendez quelques secondes que tous les pods soient mis à jour"
  exit 1
fi

echo "✅ Rolling Update effectué avec succès! ($REVISION_COUNT révisions dans l'historique)"
