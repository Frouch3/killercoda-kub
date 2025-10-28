#!/bin/bash

# Script exécuté en arrière-plan au démarrage du scénario
# Il installe et configure Microk8s

echo "🚀 Installation de Microk8s en cours..."

# Installer Microk8s via snap
snap install microk8s --classic --channel=1.28/stable

# Ajouter l'utilisateur au groupe microk8s
usermod -a -G microk8s root

# Attendre que Microk8s soit prêt
microk8s status --wait-ready

# Activer les addons essentiels
microk8s enable dns
microk8s enable storage

# Créer un alias kubectl pour simplifier
echo "alias kubectl='microk8s kubectl'" >> /root/.bashrc

# Configurer kubectl
mkdir -p /root/.kube
microk8s config > /root/.kube/config

# Marquer que le setup est terminé
touch /tmp/setup-complete

echo "✅ Microk8s installé et configuré avec succès!"
