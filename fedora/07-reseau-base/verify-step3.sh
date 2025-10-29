#!/bin/bash

# Vérifier que UFW est actif
if sudo ufw status | grep -q "Status: active"; then
    if [ -f "$HOME/parefeu_configure" ]; then
        echo "Pare-feu configuré et actif"
        exit 0
    else
        echo "Créez le fichier ~/parefeu_configure pour continuer"
        exit 1
    fi
else
    echo "Le pare-feu UFW n'est pas actif. Activez-le avec: sudo ufw enable"
    exit 1
fi
