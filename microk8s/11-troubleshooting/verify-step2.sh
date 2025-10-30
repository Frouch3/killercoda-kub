#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le pod imagepull-app existe
if ! microk8s kubectl get pod imagepull-app >/dev/null 2>&1; then
  echo "❌ Le pod 'imagepull-app' n'existe pas."
  echo "💡 Créez-le avec le fichier imagepull-pod.yaml corrigé"
  exit 1
fi

# Vérifier que le pod est Running
STATUS=$(microk8s kubectl get pod imagepull-app -o jsonpath='{.status.phase}')
if [ "$STATUS" != "Running" ]; then
  echo "❌ Le pod 'imagepull-app' n'est pas Running (status: $STATUS)"
  echo "💡 Vérifiez que l'image nginx:1.25 est correcte"
  exit 1
fi

# Vérifier que l'image utilisée est valide (nginx avec un tag existant)
IMAGE=$(microk8s kubectl get pod imagepull-app -o jsonpath='{.spec.containers[0].image}')
if ! echo "$IMAGE" | grep -q "nginx:"; then
  echo "❌ L'image doit être nginx avec un tag valide"
  exit 1
fi

echo "✅ Pod imagepull-app utilise une image valide et fonctionne!"
