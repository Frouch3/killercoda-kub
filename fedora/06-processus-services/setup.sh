#!/bin/bash

# Script d'initialisation du scénario

# Mettre à jour les paquets
apt-get update -qq 2>/dev/null

# Installer htop pour les exemples
apt-get install -y htop 2>/dev/null

# Installer nginx pour les exercices
apt-get install -y nginx 2>/dev/null

# S'assurer que nginx est démarré
systemctl start nginx 2>/dev/null

echo "Environnement prêt pour le scénario processus et services"
