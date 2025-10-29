#!/bin/bash

# Vérifier que le répertoire test_permissions existe
if [ -d "$HOME/test_permissions" ]; then
    echo "Répertoire test_permissions créé"
    exit 0
else
    echo "Créez le répertoire test_permissions pour continuer"
    exit 1
fi
