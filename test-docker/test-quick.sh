#!/bin/bash

echo "🧪 Test Rapide (Timeout Court)"
echo "=============================="
echo ""

# Nettoyer
docker rm -f killercoda-test-quick 2>/dev/null || true

echo "📦 Construction de l'image..."
docker build -t killercoda-test . -q

echo ""
echo "🚀 Lancement avec timeout de 3 minutes..."
echo ""

timeout 180 docker run --rm \
    --privileged \
    --name killercoda-test-quick \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    -v /lib/modules:/lib/modules:ro \
    killercoda-test \
    /bin/bash -c '
        echo "=== Début du test ==="
        START_TIME=$(date +%s)

        # Lancer setup en arrière-plan
        /root/setup.sh > /tmp/setup-output.log 2>&1 &
        SETUP_PID=$!

        # Attendre max 3 minutes
        timeout 180 tail -f /tmp/setup.log 2>/dev/null &
        TAIL_PID=$!

        wait $SETUP_PID
        EXIT_CODE=$?
        kill $TAIL_PID 2>/dev/null || true

        END_TIME=$(date +%s)
        ELAPSED=$((END_TIME - START_TIME))

        echo ""
        echo "=== Résultat ==="
        echo "Temps écoulé: ${ELAPSED}s"
        echo "Exit code: $EXIT_CODE"
        echo ""

        if [ $EXIT_CODE -eq 0 ]; then
            echo "✅ Installation réussie en ${ELAPSED}s"

            # Test rapide
            export PATH=$PATH:/snap/bin
            if command -v microk8s &> /dev/null; then
                echo "✅ microk8s disponible"
                microk8s version 2>&1 | head -1
            fi
        else
            echo "❌ Installation échouée après ${ELAPSED}s"
            echo ""
            echo "Dernières lignes du log:"
            tail -20 /tmp/setup.log 2>&1 || cat /tmp/setup-output.log 2>&1
        fi

        exit $EXIT_CODE
    '

EXIT_CODE=$?

echo ""
echo "=== Analyse ==="
if [ $EXIT_CODE -eq 124 ]; then
    echo "⏱️  Timeout de 3 minutes dépassé"
elif [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Test réussi"
else
    echo "❌ Test échoué (code: $EXIT_CODE)"
fi

exit $EXIT_CODE
