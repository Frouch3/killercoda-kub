#!/bin/bash

# Vérifier que le fichier de validation existe
if [ -f "$HOME/systemd_compris" ]; then
    echo "systemd compris avec succès"
    exit 0
else
    echo "Créez le fichier ~/systemd_compris pour continuer"
    exit 1
fi
