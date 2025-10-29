#!/bin/bash

# Vérifier que l'utilisateur charlie existe
if id charlie &>/dev/null; then
    echo "Utilisateur charlie créé avec succès"
    exit 0
else
    echo "L'utilisateur charlie n'existe pas encore"
    exit 1
fi
