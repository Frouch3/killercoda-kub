#!/bin/bash

if [ -f "$HOME/variables_ok" ]; then
    echo "Variables maîtrisées avec succès"
    exit 0
else
    echo "Créez le fichier ~/variables_ok pour continuer"
    exit 1
fi
