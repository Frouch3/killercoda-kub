#!/bin/bash

# Tester que l'application répond via l'Ingress
if ! curl -s -H "Host: web.local" http://127.0.0.1 | grep -q "Application Web"; then
  echo "❌ L'application ne répond pas via l'Ingress"
  echo "💡 Vérifiez que l'Ingress et le Service sont bien configurés"
  exit 1
fi

echo "✅ Application accessible via l'Ingress!"
