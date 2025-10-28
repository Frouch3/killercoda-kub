#!/bin/bash
microk8s kubectl get deployment symfony-app >/dev/null 2>&1 && [ "$(microk8s kubectl get deployment symfony-app -o jsonpath='{.status.readyReplicas}')" == "2" ] && echo "✅ Symfony déployé!" || exit 1
