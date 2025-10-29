#!/bin/bash

# Vérifier que le fichier de validation existe
if [ -f "$HOME/processus_geres" ]; then
    echo "Processus gérés avec succès"
    exit 0
else
    echo "Créez le fichier ~/processus_geres pour continuer"
    exit 1
fi
