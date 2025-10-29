#!/bin/bash

echo "🧪 Test avec monitoring en temps réel"
echo "====================================="
echo ""

# Nettoyer
docker rm -f killercoda-systemd 2>/dev/null || true

echo "📦 Construction de l'image..."
docker build -f Dockerfile.systemd -t killercoda-systemd . -q > /dev/null 2>&1

echo "🚀 Lancement du conteneur avec systemd..."
docker run --rm \
    --privileged \
    --name killercoda-systemd \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    --cgroupns=host \
    -d \
    killercoda-systemd > /dev/null

sleep 5

echo "✅ Conteneur démarré"
echo ""
echo "📋 Lancement du setup en arrière-plan dans le conteneur..."

# Lancer le setup en background
docker exec -d killercoda-systemd /bin/bash -c "cd /root && ./setup.sh > /tmp/setup-output.log 2>&1"

echo "⏳ Monitoring des logs (Ctrl+C pour arrêter)..."
echo ""

# Monitorer les logs
timeout 300 docker exec killercoda-systemd tail -f /tmp/setup.log 2>/dev/null || true

echo ""
echo "=== Vérification finale ==="

# Vérifier si le setup est terminé
if docker exec killercoda-systemd test -f /tmp/setup-complete 2>/dev/null; then
    echo "✅ Installation terminée!"
    echo ""
    docker exec killercoda-systemd /bin/bash -c 'export PATH=$PATH:/snap/bin && microk8s version | head -3'
    docker exec killercoda-systemd /bin/bash -c 'export PATH=$PATH:/snap/bin && microk8s status'
else
    echo "❌ Installation non terminée après 5 minutes"
    echo ""
    echo "Dernières lignes du log:"
    docker exec killercoda-systemd tail -30 /tmp/setup.log 2>/dev/null || echo "Pas de logs"
fi

echo ""
echo "🧹 Nettoyage..."
docker stop killercoda-systemd > /dev/null 2>&1

