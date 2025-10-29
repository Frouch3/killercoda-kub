#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le deployment existe
if ! microk8s kubectl get deployment nginx-deployment >/dev/null 2>&1; then
  echo "❌ Le deployment 'nginx-deployment' n'existe pas."
  echo "💡 Exécutez : microk8s kubectl apply -f nginx-deployment.yaml"
  exit 1
fi

# Vérifier le nombre de replicas
REPLICAS=$(microk8s kubectl get deployment nginx-deployment -o jsonpath='{.spec.replicas}')
if [ "$REPLICAS" != "2" ]; then
  echo "❌ Le deployment doit avoir 2 replicas (actuellement: $REPLICAS)"
  exit 1
fi

# Vérifier l'image
IMAGE=$(microk8s kubectl get deployment nginx-deployment -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ ! "$IMAGE" =~ nginxdemos/hello ]]; then
  echo "❌ L'image doit être nginxdemos/hello (actuellement: $IMAGE)"
  exit 1
fi

echo "✅ Deployment créé correctement avec 2 replicas!"
