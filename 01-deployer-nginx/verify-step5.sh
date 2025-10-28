#!/bin/bash

# Vérifier le nombre de replicas configurés
DESIRED_REPLICAS=$(microk8s kubectl get deployment nginx-deployment -o jsonpath='{.spec.replicas}' 2>/dev/null)

if [ -z "$DESIRED_REPLICAS" ]; then
  echo "❌ Impossible de récupérer le nombre de replicas"
  exit 1
fi

# Vérifier que le nombre de replicas a été modifié depuis l'initial (2)
if [ "$DESIRED_REPLICAS" == "2" ]; then
  echo "⚠️  Le nombre de replicas est toujours 2"
  echo "💡 Essayez de scaler : microk8s kubectl scale deployment nginx-deployment --replicas=5"
  exit 1
fi

# Vérifier que les pods sont disponibles
AVAILABLE_REPLICAS=$(microk8s kubectl get deployment nginx-deployment -o jsonpath='{.status.availableReplicas}' 2>/dev/null)

if [ "$AVAILABLE_REPLICAS" != "$DESIRED_REPLICAS" ]; then
  echo "⚠️  Pas encore tous les pods disponibles ($AVAILABLE_REPLICAS/$DESIRED_REPLICAS)"
  echo "    Attendez quelques secondes que tous les pods démarrent"
  exit 1
fi

echo "✅ Application scalée à $DESIRED_REPLICAS replicas avec succès!"
