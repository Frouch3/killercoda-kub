#!/bin/bash

if [ -f "$HOME/conditions_ok" ]; then
    echo "Conditions comprises avec succès"
    exit 0
else
    echo "Créez le fichier ~/conditions_ok pour continuer"
    exit 1
fi
