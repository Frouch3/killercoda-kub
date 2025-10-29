#!/bin/bash

if [ -f "$HOME/boucles_fonctions_ok" ]; then
    echo "Boucles et fonctions maîtrisées avec succès"
    exit 0
else
    echo "Créez le fichier ~/boucles_fonctions_ok pour continuer"
    exit 1
fi
