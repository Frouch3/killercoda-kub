#!/bin/bash

# Vérifier que l'addon ingress est activé
if ! microk8s status | grep -q "ingress: enabled"; then
  echo "❌ L'addon ingress n'est pas activé"
  echo "💡 Exécutez : microk8s enable ingress"
  exit 1
fi

# Vérifier que le pod de l'Ingress Controller est Running
if ! microk8s kubectl get pods -n ingress -l name=nginx-ingress-microk8s --no-headers 2>/dev/null | grep -q "Running"; then
  echo "❌ Le pod de l'Ingress Controller n'est pas en état Running"
  echo "💡 Attendez quelques secondes supplémentaires"
  exit 1
fi

echo "✅ Ingress Controller activé et fonctionnel!"
