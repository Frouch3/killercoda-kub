#!/bin/bash

# Logfile pour debug
LOGFILE="/tmp/setup.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "[$(date)] Démarrage de l'installation de Microk8s..."

# Vérifier et installer snap si nécessaire
if ! command -v snap &> /dev/null; then
    echo "[$(date)] snap n'est pas installé, installation en cours..."
    apt-get update -qq
    apt-get install -y -qq snapd
    systemctl enable --now snapd.socket
    systemctl start snapd.service
    echo "[$(date)] snapd installé, attente de l'initialisation..."

    # Attendre que snapd soit complètement prêt (seeding)
    for i in {1..30}; do
        if snap wait system seed.loaded 2>/dev/null; then
            echo "[$(date)] snapd est prêt (seed loaded)"
            break
        fi
        if [ $i -eq 30 ]; then
            echo "[$(date)] AVERTISSEMENT: Timeout en attendant snapd seed"
        fi
        sleep 2
    done

    ln -s /var/lib/snapd/snap /snap 2>/dev/null || true
    echo "[$(date)] snapd installé avec succès"
fi

# Ajouter /snap/bin au PATH pour cette session et de manière permanente
export PATH=$PATH:/snap/bin
echo 'export PATH=$PATH:/snap/bin' >> /root/.bashrc
echo "[$(date)] PATH configuré: $PATH"

# Vérifier que snapd est opérationnel
echo "[$(date)] Vérification de snapd..."
for i in {1..15}; do
    if snap version >/dev/null 2>&1; then
        echo "[$(date)] snapd opérationnel"
        break
    fi
    echo "[$(date)] Attente de snapd ($i/15)..."
    sleep 2
done

# Installer Microk8s via snap
echo "[$(date)] Installation de Microk8s via snap..."
snap install microk8s --classic --channel=1.28/stable

if [ $? -ne 0 ]; then
    echo "[$(date)] ERREUR: Installation de Microk8s échouée"
    exit 1
fi

echo "[$(date)] Microk8s installé avec succès"

# Ajouter l'utilisateur au groupe microk8s
echo "[$(date)] Configuration des permissions..."
usermod -a -G microk8s root
newgrp microk8s

# Attendre que Microk8s soit prêt (avec timeout de 240s)
echo "[$(date)] Attente que Microk8s soit prêt..."
microk8s status --wait-ready --timeout 240

if [ $? -ne 0 ]; then
    echo "[$(date)] ERREUR: Microk8s n'est pas prêt après 240s"
    echo "[$(date)] Tentative de diagnostic..."
    microk8s status || true
    exit 1
fi

echo "[$(date)] Microk8s est prêt!"

# Activer les addons essentiels
echo "[$(date)] Activation de l'addon DNS..."
microk8s enable dns

echo "[$(date)] Activation de l'addon Storage..."
microk8s enable storage

# Créer un alias kubectl
echo "[$(date)] Configuration de l'alias kubectl..."
echo "alias kubectl='microk8s kubectl'" >> /root/.bashrc

# Configurer kubectl
echo "[$(date)] Configuration de kubectl..."
mkdir -p /root/.kube
microk8s config > /root/.kube/config

# Marquer l'installation comme terminée
echo "[$(date)] ✅ Installation terminée avec succès!"
touch /tmp/setup-complete

echo "[$(date)] Setup complet terminé"
