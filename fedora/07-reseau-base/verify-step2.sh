#!/bin/bash

if [ -f "$HOME/config_reseau_ok" ]; then
    echo "Configuration réseau comprise avec succès"
    exit 0
else
    echo "Créez le fichier ~/config_reseau_ok pour continuer"
    exit 1
fi
