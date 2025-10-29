#!/bin/bash

# Vérifier que nginx est en cours d'exécution
if systemctl is-active --quiet nginx; then
    if [ -f "$HOME/services_geres" ]; then
        echo "Services gérés avec succès et nginx est actif"
        exit 0
    else
        echo "Créez le fichier ~/services_geres pour continuer"
        exit 1
    fi
else
    echo "nginx n'est pas actif. Démarrez-le avec: sudo systemctl start nginx"
    exit 1
fi
