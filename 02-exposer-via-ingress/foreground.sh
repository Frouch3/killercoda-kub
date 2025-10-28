#!/bin/bash

echo "🎓 Formation Microk8s - Exercice 2 : Ingress"
echo "============================================"
echo ""
echo "⏳ Préparation de l'environnement..."
echo ""

while [ ! -f /tmp/setup-complete ]; do
  sleep 2
done

source /root/.bashrc

echo "✅ Environnement prêt!"
echo ""
echo "📝 Vérification:"
microk8s kubectl version --short
echo ""
echo "🚀 Commençons!"
echo ""
