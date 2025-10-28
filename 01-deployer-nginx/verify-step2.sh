#!/bin/bash

# Vérifier qu'il y a bien 2 pods
POD_COUNT=$(microk8s kubectl get pods -l app=nginx --no-headers 2>/dev/null | wc -l)

if [ "$POD_COUNT" != "2" ]; then
  echo "❌ Il devrait y avoir 2 pods (actuellement: $POD_COUNT)"
  echo "💡 Attendez quelques secondes que les pods démarrent"
  exit 1
fi

# Vérifier que les 2 pods sont Running
RUNNING_COUNT=$(microk8s kubectl get pods -l app=nginx --no-headers 2>/dev/null | grep -c Running)

if [ "$RUNNING_COUNT" != "2" ]; then
  echo "❌ Les 2 pods ne sont pas encore en état Running"
  echo "💡 Attendez quelques secondes supplémentaires"
  exit 1
fi

echo "✅ Les 2 pods sont bien en état Running!"
