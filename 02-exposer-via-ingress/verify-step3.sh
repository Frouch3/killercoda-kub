#!/bin/bash

# Vérifier que l'Ingress existe
if ! microk8s kubectl get ingress web-ingress >/dev/null 2>&1; then
  echo "❌ L'Ingress 'web-ingress' n'existe pas"
  echo "💡 Exécutez : microk8s kubectl apply -f web-ingress.yaml"
  exit 1
fi

# Vérifier que l'Ingress a un host configuré
HOST=$(microk8s kubectl get ingress web-ingress -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ -z "$HOST" ]; then
  echo "❌ L'Ingress n'a pas de host configuré"
  exit 1
fi

echo "✅ Ingress créé pour le host: $HOST"
