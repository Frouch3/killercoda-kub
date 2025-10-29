#!/bin/bash

# Vérifier que le fichier de validation existe
if [ -f "$HOME/logs_consultes" ]; then
    echo "Logs consultés avec succès"
    exit 0
else
    echo "Créez le fichier ~/logs_consultes pour continuer"
    exit 1
fi
