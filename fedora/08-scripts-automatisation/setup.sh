#!/bin/bash

# Script d'initialisation du scénario scripting et automatisation

# Mettre à jour les paquets
apt-get update -qq 2>/dev/null

# Installer les outils utiles pour le scripting
apt-get install -y \
    vim \
    nano \
    cron \
    wget \
    curl 2>/dev/null

# S'assurer que cron est démarré
systemctl start cron 2>/dev/null
systemctl enable cron 2>/dev/null

echo "Environnement prêt pour le scripting et l'automatisation"
