#!/bin/bash

# Script d'initialisation pour le scénario "Premiers pas avec Fedora"
# Ce script prépare l'environnement pour l'exercice

# Attendre que le système soit prêt
sleep 2

# Mettre à jour les métadonnées DNF (sans installer de mises à jour)
dnf makecache --quiet 2>/dev/null || true

# S'assurer que nous sommes dans le bon répertoire
cd /root

# Nettoyer les dossiers qui pourraient exister
rm -rf mes_documents photos videos musique projets travail mon_espace 2>/dev/null || true

# Créer un message de bienvenue
cat > /root/.bash_profile << 'EOF'
# Profil Bash pour la formation Fedora

# Message de bienvenue
if [ -f ~/.welcome_shown ]; then
    :
else
    clear
    echo "=========================================="
    echo "  Bienvenue dans la formation Fedora !   "
    echo "=========================================="
    echo ""
    echo "Vous êtes dans un environnement Fedora Linux."
    echo "Vous allez apprendre les bases de la ligne de commande."
    echo ""
    echo "Bonne formation !"
    echo ""
    touch ~/.welcome_shown
fi

# Prompt personnalisé
PS1='[\u@fedora \W]\$ '
EOF

# Créer un fichier vide pour indiquer que le setup est terminé
touch /root/.setup_complete

echo "✅ Environnement prêt pour la formation Fedora"
