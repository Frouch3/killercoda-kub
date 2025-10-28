#!/bin/bash
microk8s kubectl get hpa php-app >/dev/null 2>&1 && echo "✅ HPA configuré!" || exit 1
