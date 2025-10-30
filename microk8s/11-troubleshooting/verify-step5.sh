#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod init-app existe
if ! microk8s kubectl get pod init-app >/dev/null 2>&1; then
  echo "❌ Le pod 'init-app' n'existe pas."
  echo "💡 Créez-le avec le fichier init-pod.yaml corrigé"
  exit 1
fi

# Vérifier que le pod est Running (tous les init containers ont réussi)
STATUS=$(microk8s kubectl get pod init-app -o jsonpath='{.status.phase}')
if [ "$STATUS" = "Pending" ]; then
  INIT_STATUS=$(microk8s kubectl get pod init-app -o jsonpath='{.status.containerStatuses[0].state}')
  if echo "$INIT_STATUS" | grep -q "waiting"; then
    echo "❌ Le pod 'init-app' est bloqué sur un init container"
    echo "💡 Vérifiez les logs des init containers avec kubectl logs init-app -c <container>"
    exit 1
  fi
fi

if [ "$STATUS" != "Running" ]; then
  echo "❌ Le pod 'init-app' n'est pas Running (status: $STATUS)"
  echo "💡 Les init containers doivent tous réussir pour que le pod démarre"
  exit 1
fi

# Vérifier que les init containers se sont bien exécutés
INIT_COUNT=$(microk8s kubectl get pod init-app -o jsonpath='{.spec.initContainers}' | grep -c "name")
if [ "$INIT_COUNT" -lt 2 ]; then
  echo "⚠️  Le pod devrait avoir 2 init containers"
fi

# Vérifier les logs d'un init container pour confirmer qu'il s'est exécuté
if ! microk8s kubectl logs init-app -c wait-for-database 2>/dev/null | grep -q "DB ready"; then
  echo "⚠️  L'init container 'wait-for-database' ne semble pas avoir terminé correctement"
  echo "💡 Vérifiez les logs avec: kubectl logs init-app -c wait-for-database"
else
  echo "✅ Init containers ont terminé avec succès et le pod est Running!"
fi
