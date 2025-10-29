#!/bin/bash

# Vérification de l'étape 4 : Naviguer entre les dossiers
# On vérifie que l'utilisateur comprend cd, pwd, et les chemins

# Déterminer le dossier personnel
HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que la structure mon_espace existe toujours
if [ ! -d "$HOME_DIR/mon_espace" ]; then
    echo "❌ Le dossier 'mon_espace' n'existe plus. Recréez-le d'abord !"
    exit 1
fi

# Vérifier que l'utilisateur sait utiliser pwd
if ! pwd &>/dev/null; then
    echo "❌ La commande 'pwd' ne fonctionne pas"
    exit 1
fi

# Vérifier que cd fonctionne
cd "$HOME_DIR" &>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Impossible de naviguer vers le dossier personnel"
    exit 1
fi

# Vérifier qu'on peut naviguer dans mon_espace
cd "$HOME_DIR/mon_espace" &>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Impossible de naviguer dans mon_espace"
    exit 1
fi

# Vérifier qu'on peut naviguer dans les sous-dossiers
cd "$HOME_DIR/mon_espace/personnel/documents" &>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Impossible de naviguer dans mon_espace/personnel/documents"
    exit 1
fi

# Vérifier qu'on peut remonter
cd "$HOME_DIR/mon_espace/personnel" &>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Problème de navigation entre les dossiers"
    exit 1
fi

echo "✅ Parfait ! Vous maîtrisez la navigation avec cd."
exit 0
