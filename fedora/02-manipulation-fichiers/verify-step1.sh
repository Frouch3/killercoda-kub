#!/bin/bash

# Vérification de l'étape 1 : Créer des fichiers

HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que l'utilisateur a créé le dossier projet
if [ ! -d "$HOME_DIR/projet" ]; then
    echo "❌ Le dossier 'projet' n'existe pas dans votre dossier personnel"
    echo "💡 Créez-le avec : mkdir -p ~/projet"
    exit 1
fi

# Vérifier qu'au moins un fichier a été créé dans projet
if [ ! -f "$HOME_DIR/projet/README.md" ] && [ ! -f "$HOME_DIR/projet/TODO.md" ]; then
    echo "❌ Aucun fichier trouvé dans ~/projet"
    echo "💡 Créez des fichiers avec : touch ~/projet/README.md"
    exit 1
fi

# Vérifier que touch fonctionne
cd "$HOME_DIR"
if ! touch .test_file_verification 2>/dev/null; then
    echo "❌ La commande 'touch' ne fonctionne pas correctement"
    exit 1
fi
rm -f .test_file_verification

echo "✅ Parfait ! Vous savez créer des fichiers avec touch et echo."
exit 0
