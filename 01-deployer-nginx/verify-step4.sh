#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le service répond
SERVICE_IP=$(microk8s kubectl get svc nginx-service -o jsonpath='{.spec.clusterIP}' 2>/dev/null)

if [ -z "$SERVICE_IP" ]; then
  echo "❌ Impossible de récupérer l'IP du service"
  exit 1
fi

# Tester la connectivité au service
if ! curl -s --max-time 5 http://$SERVICE_IP > /dev/null; then
  echo "❌ Le service ne répond pas aux requêtes HTTP"
  echo "💡 Vérifiez que les pods sont bien Running et que le Service a des endpoints"
  exit 1
fi

echo "✅ L'application Nginx est accessible et répond correctement!"
