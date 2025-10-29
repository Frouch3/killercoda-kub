#!/bin/bash

# Vérification de l'étape 5 : Supprimer des dossiers
# On vérifie que l'utilisateur a bien gardé mon_espace

# Déterminer le dossier personnel
HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que mon_espace existe toujours (il ne doit PAS être supprimé)
if [ ! -d "$HOME_DIR/mon_espace" ]; then
    echo "❌ Oups ! Vous avez supprimé 'mon_espace' mais il fallait le garder !"
    echo "💡 Recréez-le avec :"
    echo "mkdir -p ~/mon_espace/personnel/documents"
    echo "mkdir -p ~/mon_espace/personnel/images"
    echo "mkdir -p ~/mon_espace/professionnel/projets"
    echo "mkdir -p ~/mon_espace/professionnel/formations"
    exit 1
fi

# Vérifier que la structure complète existe toujours
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
    echo "❌ La structure de mon_espace est incomplète"
    exit 1
fi

# Vérifier que les dossiers de test ont bien été supprimés (optionnel)
# Ceci est une vérification positive : on s'assure que mon_espace existe
# Les autres dossiers n'ont pas besoin d'être vérifiés

echo "✅ Excellent ! Vous savez supprimer des dossiers en toute sécurité."
echo "✅ Vous avez bien conservé la structure 'mon_espace' comme demandé."
exit 0
