#!/bin/bash
export PATH=$PATH:/snap/bin

if ! microk8s kubectl get pod resource-demo >/dev/null 2>&1; then
  echo "❌ Pod 'resource-demo' n'existe pas."
  exit 1
fi

if ! microk8s kubectl get pod resource-demo -o yaml | grep -q "requests"; then
  echo "❌ Le pod n'a pas de requests configurées"
  exit 1
fi

echo "✅ Resources configurées correctement!"
