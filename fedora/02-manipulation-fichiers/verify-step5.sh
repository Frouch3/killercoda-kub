#!/bin/bash

# Vérification de l'étape 5 : Supprimer des fichiers

HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que rm fonctionne
if ! command -v rm &>/dev/null; then
    echo "❌ La commande 'rm' n'est pas disponible"
    exit 1
fi

# Test de suppression simple
cd "$HOME_DIR"
echo "test" > .test_to_delete.txt
if ! rm .test_to_delete.txt 2>/dev/null; then
    echo "❌ La suppression de fichiers ne fonctionne pas"
    rm -f .test_to_delete.txt
    exit 1
fi

# Vérifier que le fichier n'existe plus
if [ -f .test_to_delete.txt ]; then
    echo "❌ Le fichier existe encore après rm"
    rm -f .test_to_delete.txt
    exit 1
fi

# Test de suppression récursive
mkdir -p .test_dir_to_delete/sub
touch .test_dir_to_delete/file.txt
touch .test_dir_to_delete/sub/file2.txt

if ! rm -r .test_dir_to_delete 2>/dev/null; then
    echo "❌ La suppression récursive ne fonctionne pas"
    rm -rf .test_dir_to_delete
    exit 1
fi

# Vérifier que le dossier n'existe plus
if [ -d .test_dir_to_delete ]; then
    echo "❌ Le dossier existe encore après rm -r"
    rm -rf .test_dir_to_delete
    exit 1
fi

# Message de prudence
echo "✅ Vous savez supprimer des fichiers de façon sécurisée."
echo "⚠️  N'oubliez pas : toujours utiliser -i pour les fichiers importants !"
exit 0
