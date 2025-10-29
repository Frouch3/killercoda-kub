#!/bin/bash

if [ -f "$HOME/README" ] && [ -f "$HOME/telechargements_testes" ]; then
    echo "Téléchargements réussis avec wget et curl"
    exit 0
else
    echo "Téléchargez le fichier README et créez le fichier ~/telechargements_testes"
    exit 1
fi
