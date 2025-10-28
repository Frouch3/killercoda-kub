#!/bin/bash

# Logfile pour debug
LOGFILE="/tmp/setup.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "[$(date)] Démarrage de l'installation de Microk8s..."

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

# Attendre que Microk8s soit prêt (avec timeout de 120s)
echo "[$(date)] Attente que Microk8s soit prêt..."
microk8s status --wait-ready --timeout 120

if [ $? -ne 0 ]; then
    echo "[$(date)] ERREUR: Microk8s n'est pas prêt après 120s"
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

# Vérification finale
echo "[$(date)] Vérification de l'installation..."
microk8s kubectl version --short > /tmp/kubectl-test.log 2>&1

if [ $? -eq 0 ]; then
    echo "[$(date)] ✅ Installation terminée avec succès!"
    touch /tmp/setup-complete
else
    echo "[$(date)] ❌ Erreur lors du test kubectl"
    cat /tmp/kubectl-test.log
    exit 1
fi

echo "[$(date)] Setup complet terminé"
