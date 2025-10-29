#!/bin/bash

# Vérifier que le fichier de validation existe
if [ -f "$HOME/processus_explores" ]; then
    echo "Processus explorés avec succès"
    exit 0
else
    echo "Créez le fichier ~/processus_explores pour continuer"
    exit 1
fi
