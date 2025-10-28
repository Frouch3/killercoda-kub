#!/bin/bash
microk8s kubectl get deployment php-app >/dev/null 2>&1 && echo "✅ Application déployée!" || exit 1
