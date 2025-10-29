#!/bin/bash

# Script d'initialisation du scénario réseau

# Mettre à jour les paquets
apt-get update -qq 2>/dev/null

# Installer les outils réseau utiles
apt-get install -y \
    iputils-ping \
    traceroute \
    dnsutils \
    net-tools \
    curl \
    wget \
    netcat \
    nmap \
    ufw \
    lsof 2>/dev/null

# Installer nginx pour les exemples
apt-get install -y nginx 2>/dev/null
systemctl start nginx 2>/dev/null

echo "Environnement réseau prêt pour le scénario"
