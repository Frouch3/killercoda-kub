#!/bin/bash

echo "🧪 Test du Scénario Killercoda en Local (Mode CI)"
echo "=================================================="
echo ""

# Nettoyer les anciens conteneurs
docker rm -f killercoda-test 2>/dev/null || true

echo "📦 Construction de l'image Docker..."
docker build -t killercoda-test . -q

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la construction de l'image"
    exit 1
fi

echo ""
echo "🚀 Lancement du conteneur en mode privilégié..."
docker run --rm \
    --privileged \
    --name killercoda-test \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    -v /lib/modules:/lib/modules:ro \
    killercoda-test \
    /bin/bash -c '
        echo "🎓 Simulation de l'\''environnement Killercoda"
        echo "============================================="
        echo ""
        echo "📋 Étape 1: Lancement du setup.sh en arrière-plan"
        /root/setup.sh > /tmp/setup-output.log 2>&1 &
        SETUP_PID=$!
        echo "   PID du setup: $SETUP_PID"
        echo ""

        echo "📋 Étape 2: Lancement du foreground.sh (vue utilisateur)"
        echo "----------------------------------------"
        /root/foreground.sh
        echo "----------------------------------------"
        echo ""

        echo "📋 Étape 3: Attente de la fin du setup"
        wait $SETUP_PID
        SETUP_EXIT=$?
        echo "   Exit code du setup: $SETUP_EXIT"
        echo ""

        if [ $SETUP_EXIT -eq 0 ]; then
            echo "✅ Setup terminé avec succès"
            echo ""
            echo "📋 Étape 4: Test de la commande microk8s"
            export PATH=$PATH:/snap/bin
            if command -v microk8s &> /dev/null; then
                echo "   ✅ microk8s est dans le PATH"
                echo ""
                echo "   Version de Microk8s:"
                microk8s version 2>&1 | head -3
                echo ""
                echo "   Statut de Microk8s:"
                microk8s status 2>&1 | head -10
            else
                echo "   ❌ microk8s n'\''est pas dans le PATH"
                echo ""
                echo "   Contenu de /snap/bin:"
                ls -la /snap/bin/ 2>&1 | head -10
                exit 1
            fi
            echo ""

            echo "📋 Étape 5: Test du script de vérification"
            if /root/verify-step1.sh 2>&1; then
                echo "   ✅ Script de vérification OK"
            else
                echo "   ⚠️  Script de vérification échoué (normal si pas de deployment)"
            fi
        else
            echo "❌ Setup a échoué"
            echo ""
            echo "📋 Logs du setup (dernières 50 lignes):"
            tail -50 /tmp/setup.log 2>&1 || cat /tmp/setup-output.log 2>&1 || echo "Pas de logs disponibles"
            exit 1
        fi

        echo ""
        echo "🎉 Test terminé avec succès"
    '

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Tous les tests sont passés!"
else
    echo "❌ Des erreurs sont survenues (code: $EXIT_CODE)"
fi

exit $EXIT_CODE
