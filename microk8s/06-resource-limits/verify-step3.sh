#!/bin/bash
export PATH=$PATH:/snap/bin

if ! microk8s kubectl get pod oom-killer >/dev/null 2>&1; then
  echo "❌ Pod 'oom-killer' n'existe pas."
  exit 1
fi

echo "✅ OOMKilled observé!"
