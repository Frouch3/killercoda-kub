#!/bin/bash

if [ -f "$HOME/connectivite_testee" ]; then
    echo "Connectivité testée avec succès"
    exit 0
else
    echo "Créez le fichier ~/connectivite_testee pour continuer"
    exit 1
fi
