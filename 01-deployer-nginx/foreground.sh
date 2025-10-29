#!/bin/bash

echo "🎓 Formation Microk8s - Exercice 1"
echo "=================================="
echo ""
echo "⏳ Préparation de l'environnement en cours..."
echo "   Installation de Microk8s (environ 3-5 minutes)"
echo ""
echo "📋 Logs d'installation :"
echo "─────────────────────────────────────────────────────────"
echo ""

# Suivre les logs d'installation en temps réel
tail -f /tmp/setup.log 2>/dev/null &
TAIL_PID=$!

# Attendre que le setup soit terminé (max 420s)
elapsed=0
max_wait=420

while [ ! -f /tmp/setup-complete ]; do
    sleep 2
    elapsed=$((elapsed + 2))

    # Timeout de sécurité
    if [ $elapsed -ge $max_wait ]; then
        echo ""
        echo "⚠️  L'installation prend plus de temps que prévu (${elapsed}s)"
        echo ""
        echo "🔧 Vous pouvez installer manuellement :"
        echo "   snap install microk8s --classic"
        echo ""
        break
    fi
done

# Tuer le tail
kill $TAIL_PID 2>/dev/null || true

echo ""
echo "─────────────────────────────────────────────────────────"
echo ""

# Vérifier si l'installation a réussi
if [ -f /tmp/setup-complete ]; then
    # Sourcer le bashrc pour avoir l'alias kubectl
    source /root/.bashrc

    echo "✅ Environnement prêt!"
    echo ""
    echo "📝 Vérification rapide:"
    microk8s kubectl version --short 2>/dev/null || echo "⚠️  kubectl pas encore prêt, attendez quelques secondes"
    echo ""
    echo "🚀 Vous pouvez maintenant commencer l'exercice!"
    echo ""
    echo "💡 Commandes utiles :"
    echo "   microk8s kubectl get nodes    # Voir les nœuds"
    echo "   microk8s kubectl get pods     # Voir les pods"
    echo "   microk8s status              # Statut de Microk8s"
else
    echo "❌ L'installation n'est pas encore terminée"
    echo ""
    echo "📋 Consultez les logs pour plus d'infos :"
    echo "   cat /tmp/setup.log"
    echo ""
    echo "🔧 Installation manuelle si besoin :"
    echo "   snap install microk8s --classic"
    echo "   microk8s status --wait-ready"
fi

echo ""
