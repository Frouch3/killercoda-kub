#!/bin/bash
microk8s kubectl get ingress symfony-ingress >/dev/null 2>&1 && echo "✅ Ingress créé!" || exit 1
