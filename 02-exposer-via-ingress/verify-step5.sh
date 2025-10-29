#!/bin/bash


# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
# Vérifier que l'API est déployée
if ! microk8s kubectl get deployment api-app >/dev/null 2>&1; then
  echo "❌ Le deployment 'api-app' n'existe pas"
  echo "💡 Exécutez : microk8s kubectl apply -f api-deployment.yaml"
  exit 1
fi

# Vérifier que l'Ingress a plusieurs paths
PATH_COUNT=$(microk8s kubectl get ingress web-ingress -o jsonpath='{.spec.rules[0].http.paths[*].path}' 2>/dev/null | wc -w)
if [ "$PATH_COUNT" -lt "2" ]; then
  echo "❌ L'Ingress devrait avoir au moins 2 paths configurés"
  echo "💡 Mettez à jour l'Ingress avec web-ingress-multi.yaml"
  exit 1
fi

# Tester que l'API répond
if ! curl -s -H "Host: web.local" http://127.0.0.1/api | grep -q "api"; then
  echo "⚠️  L'API ne répond pas encore"
  echo "    Attendez quelques secondes que les pods démarrent"
  exit 1
fi

echo "✅ Routing multi-paths configuré avec succès!"
