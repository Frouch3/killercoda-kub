#!/bin/bash

echo "🧪 Test avec systemd dans Docker"
echo "================================="
echo ""

# Nettoyer
docker rm -f killercoda-systemd 2>/dev/null || true

echo "📦 Construction de l'image avec systemd..."
docker build -f Dockerfile.systemd -t killercoda-systemd . -q

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la construction"
    exit 1
fi

echo "✅ Image construite"
echo ""
echo "🚀 Lancement du conteneur avec systemd..."
echo "   (Cela peut prendre 5-7 minutes pour l'installation complète)"
echo ""

# Lancer le conteneur avec systemd
docker run --rm \
    --privileged \
    --name killercoda-systemd \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    --cgroupns=host \
    -d \
    killercoda-systemd

if [ $? -ne 0 ]; then
    echo "❌ Impossible de démarrer le conteneur"
    exit 1
fi

echo "✅ Conteneur démarré (PID 1 = systemd)"
echo ""

# Attendre que systemd soit prêt
echo "⏳ Attente que systemd soit prêt..."
sleep 5

# Lancer le test dans le conteneur
echo "🧪 Lancement du test..."
echo ""

docker exec killercoda-systemd /root/run-test.sh

EXIT_CODE=$?

echo ""
echo "🧹 Nettoyage..."
docker stop killercoda-systemd >/dev/null 2>&1

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Test réussi!"
else
    echo "❌ Test échoué (code: $EXIT_CODE)"
    echo ""
    echo "Pour débugger:"
    echo "  docker run --rm --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host -it killercoda-systemd /bin/bash"
fi

exit $EXIT_CODE
