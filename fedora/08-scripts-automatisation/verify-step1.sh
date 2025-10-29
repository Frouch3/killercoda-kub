#!/bin/bash

if [ -f "$HOME/scripts_bases_ok" ]; then
    echo "Bases du scripting comprises avec succès"
    exit 0
else
    echo "Créez le fichier ~/scripts_bases_ok pour continuer"
    exit 1
fi
