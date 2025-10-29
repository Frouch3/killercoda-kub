#!/bin/bash

echo "🧪 Test du Scénario Killercoda en Local"
echo "======================================="
echo ""

# Nettoyer les anciens conteneurs
docker rm -f killercoda-test 2>/dev/null || true

echo "📦 Construction de l'image Docker..."
docker build -t killercoda-test .

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la construction de l'image"
    exit 1
fi

echo ""
echo "🚀 Lancement du conteneur en mode privilégié (nécessaire pour snap)..."
docker run -it --rm \
    --privileged \
    --name killercoda-test \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    -v /lib/modules:/lib/modules:ro \
    killercoda-test \
    /bin/bash -c "
        echo '🎓 Simulation de l'\''environnement Killercoda'
        echo '============================================='
        echo ''
        echo '📋 Étape 1: Lancement du setup.sh en arrière-plan'
        /root/setup.sh &
        SETUP_PID=\$!
        echo '   PID du setup: '\$SETUP_PID
        echo ''

        echo '📋 Étape 2: Lancement du foreground.sh (vue utilisateur)'
        /root/foreground.sh
        echo ''

        echo '📋 Étape 3: Attente de la fin du setup'
        wait \$SETUP_PID
        SETUP_EXIT=\$?
        echo '   Exit code du setup: '\$SETUP_EXIT
        echo ''

        if [ \$SETUP_EXIT -eq 0 ]; then
            echo '✅ Setup terminé avec succès'
            echo ''
            echo '📋 Étape 4: Test de la commande microk8s'
            export PATH=\$PATH:/snap/bin
            if command -v microk8s &> /dev/null; then
                echo '   ✅ microk8s est dans le PATH'
                microk8s version || true
                echo ''
                microk8s status || true
            else
                echo '   ❌ microk8s n'\''est pas dans le PATH'
                exit 1
            fi
            echo ''

            echo '📋 Étape 5: Test du script de vérification'
            /root/verify-step1.sh || echo '   Note: La vérification peut échouer si pas de deployment créé'
        else
            echo '❌ Setup a échoué'
            echo ''
            echo '📋 Logs du setup:'
            cat /tmp/setup.log || true
            exit 1
        fi

        echo ''
        echo '🎉 Test terminé'
        echo ''
        echo '💡 Pour entrer dans le conteneur:'
        echo '   docker run -it --privileged killercoda-test /bin/bash'
    "
