#!/bin/bash

if [ -f "$HOME/connexions_analysees" ]; then
    echo "Connexions réseau analysées avec succès"
    exit 0
else
    echo "Créez le fichier ~/connexions_analysees pour continuer"
    exit 1
fi
