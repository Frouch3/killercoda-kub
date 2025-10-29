#!/bin/bash

# Vérifier que le fichier de validation existe
if [ ! -f "$HOME/automatisation_ok" ]; then
    echo "Créez le fichier ~/automatisation_ok pour continuer"
    exit 1
fi

# Vérifier qu'une crontab existe
if crontab -l &>/dev/null; then
    echo "Automatisation maîtrisée avec succès - crontab configurée"
    exit 0
else
    echo "Configurez une crontab avec 'crontab -e'"
    exit 1
fi
