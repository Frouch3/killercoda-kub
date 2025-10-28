#!/bin/bash
echo "🚀 Installation de Microk8s..."
snap install microk8s --classic --channel=1.28/stable
usermod -a -G microk8s root
microk8s status --wait-ready
microk8s enable dns storage
echo "alias kubectl='microk8s kubectl'" >> /root/.bashrc
mkdir -p /root/.kube
microk8s config > /root/.kube/config
touch /tmp/setup-complete
echo "✅ Microk8s prêt!"
