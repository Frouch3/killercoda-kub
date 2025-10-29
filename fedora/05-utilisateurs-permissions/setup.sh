#!/bin/bash

# Script d'initialisation du scénario

# Créer le groupe developpeurs qui sera utilisé dans les exercices
groupadd developpeurs 2>/dev/null

# Créer les utilisateurs alice et bob pour les exemples
useradd -m -s /bin/bash alice 2>/dev/null
echo "alice:Password123" | chpasswd 2>/dev/null

useradd -m -s /bin/bash -c "Bob Martin" -G sudo bob 2>/dev/null
echo "bob:Password123" | chpasswd 2>/dev/null

# S'assurer que les outils nécessaires sont installés
apt-get update -qq 2>/dev/null

echo "Environnement prêt pour le scénario utilisateurs et permissions"
