#!/bin/bash

# Vérification de l'étape 2 : Explorer l'arborescence Linux
# On vérifie que les dossiers système existent et sont accessibles

# Vérifier que les dossiers principaux existent
DIRS=("/" "/home" "/etc" "/var" "/usr")

for dir in "${DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "❌ Erreur : Le dossier $dir n'existe pas ou n'est pas accessible"
        exit 1
    fi
done

# Vérifier que l'utilisateur peut lister ces dossiers
if ! ls / &>/dev/null; then
    echo "❌ Erreur : Impossible de lister le contenu de la racine /"
    exit 1
fi

if ! ls /home &>/dev/null; then
    echo "❌ Erreur : Impossible de lister le contenu de /home"
    exit 1
fi

if ! ls /etc &>/dev/null; then
    echo "❌ Erreur : Impossible de lister le contenu de /etc"
    exit 1
fi

echo "✅ Excellent ! Vous savez maintenant explorer l'arborescence Linux."
exit 0
