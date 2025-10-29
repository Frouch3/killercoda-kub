#!/bin/bash

# Vérification de l'étape 3 : Créer des dossiers
# On vérifie que l'utilisateur a créé la structure mon_espace

# Déterminer le dossier personnel
HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que le dossier mon_espace existe
if [ ! -d "$HOME_DIR/mon_espace" ]; then
    echo "❌ Le dossier 'mon_espace' n'existe pas dans votre dossier personnel"
    echo "💡 Créez-le avec : mkdir -p ~/mon_espace/personnel/documents"
    exit 1
fi

# Vérifier la structure complète
REQUIRED_DIRS=(
    "$HOME_DIR/mon_espace/personnel"
    "$HOME_DIR/mon_espace/personnel/documents"
    "$HOME_DIR/mon_espace/personnel/images"
    "$HOME_DIR/mon_espace/professionnel"
    "$HOME_DIR/mon_espace/professionnel/projets"
    "$HOME_DIR/mon_espace/professionnel/formations"
)

MISSING=0
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "❌ Dossier manquant : $dir"
        MISSING=1
    fi
done

if [ $MISSING -eq 1 ]; then
    echo ""
    echo "💡 Créez la structure complète avec :"
    echo "mkdir -p ~/mon_espace/personnel/documents"
    echo "mkdir -p ~/mon_espace/personnel/images"
    echo "mkdir -p ~/mon_espace/professionnel/projets"
    echo "mkdir -p ~/mon_espace/professionnel/formations"
    exit 1
fi

echo "✅ Bravo ! Vous avez créé toute la structure de dossiers correctement."
exit 0
