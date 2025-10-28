#!/bin/bash

echo "🚀 Installation de Microk8s en cours..."

snap install microk8s --classic --channel=1.28/stable
usermod -a -G microk8s root
microk8s status --wait-ready

# Activer DNS et Storage
microk8s enable dns storage

# Créer alias
echo "alias kubectl='microk8s kubectl'" >> /root/.bashrc

# Configurer kubectl
mkdir -p /root/.kube
microk8s config > /root/.kube/config

touch /tmp/setup-complete
echo "✅ Microk8s installé et configuré!"
