#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod crashloop-app existe et est Running
if ! microk8s kubectl get pod crashloop-app >/dev/null 2>&1; then
  echo "❌ Le pod 'crashloop-app' n'existe pas."
  echo "💡 Créez-le avec le fichier crashloop-pod.yaml corrigé"
  exit 1
fi

# Vérifier que le pod est Running
STATUS=$(microk8s kubectl get pod crashloop-app -o jsonpath='{.status.phase}')
if [ "$STATUS" != "Running" ]; then
  echo "❌ Le pod 'crashloop-app' n'est pas Running (status: $STATUS)"
  echo "💡 Vérifiez que vous avez corrigé la commande dans le pod"
  exit 1
fi

# Vérifier que le nombre de restarts est faible (le pod a été corrigé)
RESTARTS=$(microk8s kubectl get pod crashloop-app -o jsonpath='{.status.containerStatuses[0].restartCount}')
if [ "$RESTARTS" -gt 5 ]; then
  echo "⚠️  Le pod a redémarré $RESTARTS fois. Cela suggère qu'il crashait avant."
  echo "💡 C'est normal si vous venez de le corriger. Assurez-vous qu'il ne redémarre plus."
fi

echo "✅ Pod crashloop-app est Running et corrigé!"
