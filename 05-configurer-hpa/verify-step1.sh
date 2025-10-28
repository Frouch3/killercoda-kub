#!/bin/bash
microk8s kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1 && echo "✅ Metrics Server activé!" || exit 1
