#!/bin/bash
snap install microk8s --classic --channel=1.28/stable
usermod -a -G microk8s root
microk8s status --wait-ready
microk8s enable dns storage ingress
echo "alias kubectl='microk8s kubectl'" >> /root/.bashrc
mkdir -p /root/.kube && microk8s config > /root/.kube/config
touch /tmp/setup-complete
