#!/bin/bash
export PATH=$PATH:/snap/bin

for pod in guaranteed burstable besteffort; do
  if ! microk8s kubectl get pod $pod >/dev/null 2>&1; then
    echo "❌ Pod '$pod' n'existe pas."
    exit 1
  fi
done

echo "✅ Les 3 classes QoS créées!"
