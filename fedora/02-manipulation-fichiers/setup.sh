#!/bin/bash

# Script d'initialisation pour le scénario "Manipulation de fichiers"

# Attendre que le système soit prêt
sleep 2

# Mettre à jour les métadonnées DNF (sans installer de mises à jour)
dnf makecache --quiet 2>/dev/null || true

# S'assurer que nous sommes dans le bon répertoire
cd /root

# Nettoyer les fichiers/dossiers qui pourraient exister
rm -rf projet documents sauvegardes backup atelier atelier_backup 2>/dev/null || true
rm -rf citations.txt long_fichier.txt rapport.txt desordre 2>/dev/null || true
rm -rf file*.txt test*.txt temp*.txt log*.txt 2>/dev/null || true

# Créer un profil bash personnalisé
cat > /root/.bash_profile << 'EOF'
# Profil Bash pour la formation Fedora - Manipulation de fichiers

# Message de bienvenue
if [ -f ~/.welcome_shown ]; then
    :
else
    clear
    echo "=========================================="
    echo "   Manipulation de fichiers - Fedora     "
    echo "=========================================="
    echo ""
    echo "Dans ce scénario, vous allez apprendre à :"
    echo "  - Créer des fichiers"
    echo "  - Afficher leur contenu"
    echo "  - Copier des fichiers"
    echo "  - Déplacer et renommer"
    echo "  - Supprimer en toute sécurité"
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

echo "✅ Environnement prêt pour la manipulation de fichiers"
