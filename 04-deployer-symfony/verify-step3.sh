#!/bin/bash
microk8s kubectl get job symfony-migrations -o jsonpath='{.status.succeeded}' | grep -q "1" && echo "✅ Job complété!" || exit 1
