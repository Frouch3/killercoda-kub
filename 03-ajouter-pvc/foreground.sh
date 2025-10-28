#!/bin/bash
echo "🎓 Formation Microk8s - Exercice 3 : PVC"
echo "========================================"
echo "⏳ Préparation..."
while [ ! -f /tmp/setup-complete ]; do sleep 2; done
source /root/.bashrc
echo "✅ Prêt!"
microk8s kubectl version --short
echo ""
