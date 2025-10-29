#!/bin/bash

# Vérification de l'étape 2 : Afficher le contenu des fichiers

HOME_DIR=$(eval echo ~$(whoami))

# Vérifier que les commandes fonctionnent
if ! command -v cat &>/dev/null; then
    echo "❌ La commande 'cat' n'est pas disponible"
    exit 1
fi

if ! command -v less &>/dev/null; then
    echo "❌ La commande 'less' n'est pas disponible"
    exit 1
fi

if ! command -v head &>/dev/null; then
    echo "❌ La commande 'head' n'est pas disponible"
    exit 1
fi

if ! command -v tail &>/dev/null; then
    echo "❌ La commande 'tail' n'est pas disponible"
    exit 1
fi

if ! command -v wc &>/dev/null; then
    echo "❌ La commande 'wc' n'est pas disponible"
    exit 1
fi

# Vérifier qu'au moins un fichier existe pour tester
if [ ! -f "$HOME_DIR/long_fichier.txt" ] && [ ! -f "$HOME_DIR/citations.txt" ]; then
    echo "❌ Aucun fichier de test trouvé (long_fichier.txt ou citations.txt)"
    echo "💡 Créez un fichier de test avec : echo 'test' > ~/test.txt"
    exit 1
fi

echo "✅ Excellent ! Vous savez afficher et explorer le contenu des fichiers."
exit 0
