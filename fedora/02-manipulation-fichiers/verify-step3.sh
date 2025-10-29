#!/bin/bash

# Vérification de l'étape 3 : Copier des fichiers

HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que cp fonctionne
if ! command -v cp &>/dev/null; then
    echo "❌ La commande 'cp' n'est pas disponible"
    exit 1
fi

# Vérifier qu'au moins un dossier de sauvegarde existe
if [ ! -d "$HOME_DIR/sauvegardes" ] && [ ! -d "$HOME_DIR/backup" ] && [ ! -d "$HOME_DIR/atelier_backup" ]; then
    echo "❌ Aucun dossier de sauvegarde trouvé"
    echo "💡 Créez un dossier et copiez-y des fichiers :"
    echo "   mkdir ~/sauvegardes"
    echo "   cp ~/projet/README.md ~/sauvegardes/"
    exit 1
fi

# Test de copie simple
cd "$HOME_DIR"
echo "test" > .test_original.txt
if ! cp .test_original.txt .test_copie.txt 2>/dev/null; then
    echo "❌ La copie de fichiers ne fonctionne pas correctement"
    rm -f .test_original.txt .test_copie.txt
    exit 1
fi

# Test de copie récursive
mkdir -p .test_dir/sub
if ! cp -r .test_dir .test_dir_backup 2>/dev/null; then
    echo "❌ La copie récursive (-r) ne fonctionne pas"
    rm -rf .test_original.txt .test_copie.txt .test_dir .test_dir_backup
    exit 1
fi

# Nettoyage
rm -rf .test_original.txt .test_copie.txt .test_dir .test_dir_backup

echo "✅ Bravo ! Vous maîtrisez la copie de fichiers et dossiers."
exit 0
