#!/bin/bash

# Vérification de l'étape 4 : Déplacer et renommer des fichiers

HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que mv fonctionne
if ! command -v mv &>/dev/null; then
    echo "❌ La commande 'mv' n'est pas disponible"
    exit 1
fi

# Test de renommage
cd "$HOME_DIR"
echo "test" > .test_before.txt
if ! mv .test_before.txt .test_after.txt 2>/dev/null; then
    echo "❌ Le renommage de fichiers ne fonctionne pas"
    rm -f .test_before.txt .test_after.txt
    exit 1
fi

# Vérifier que l'ancien nom n'existe plus
if [ -f .test_before.txt ]; then
    echo "❌ Le fichier original existe encore après mv (devrait être renommé)"
    rm -f .test_before.txt .test_after.txt
    exit 1
fi

# Vérifier que le nouveau nom existe
if [ ! -f .test_after.txt ]; then
    echo "❌ Le fichier renommé n'existe pas"
    rm -f .test_after.txt
    exit 1
fi

# Test de déplacement
mkdir -p .test_dest
if ! mv .test_after.txt .test_dest/ 2>/dev/null; then
    echo "❌ Le déplacement de fichiers ne fonctionne pas"
    rm -rf .test_after.txt .test_dest
    exit 1
fi

# Vérifier que le fichier est bien dans la destination
if [ ! -f .test_dest/.test_after.txt ]; then
    echo "❌ Le fichier n'a pas été déplacé correctement"
    rm -rf .test_dest
    exit 1
fi

# Nettoyage
rm -rf .test_dest

echo "✅ Parfait ! Vous savez déplacer et renommer des fichiers avec mv."
exit 0
