#!/bin/bash
microk8s kubectl get statefulset postgres >/dev/null 2>&1 && microk8s kubectl get pod postgres-0 -o jsonpath='{.status.phase}' | grep -q "Running" && echo "✅ PostgreSQL déployé!" || exit 1
