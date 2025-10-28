#!/bin/bash

# Script exécuté dans le terminal visible de l'utilisateur

echo "🎓 Formation Microk8s - Exercice 1"
echo "=================================="
echo ""
echo "⏳ Préparation de l'environnement en cours..."
echo "   (Cela prend environ 30-60 secondes)"
echo ""

# Attendre que le setup soit terminé
while [ ! -f /tmp/setup-complete ]; do
  sleep 2
done

# Sourcer le bashrc pour avoir l'alias kubectl
source /root/.bashrc

echo "✅ Environnement prêt!"
echo ""
echo "📝 Vérification rapide:"
microk8s kubectl version --short
echo ""
echo "🚀 Vous pouvez maintenant commencer l'exercice!"
echo ""
