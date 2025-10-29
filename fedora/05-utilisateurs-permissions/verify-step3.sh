#!/bin/bash

# Vérifier que exercice.txt existe avec les bonnes permissions (640)
if [ -f "$HOME/exercice.txt" ]; then
    perms=$(stat -c "%a" "$HOME/exercice.txt" 2>/dev/null)
    if [ "$perms" = "640" ]; then
        echo "Fichier exercice.txt avec permissions correctes (640)"
        exit 0
    else
        echo "Le fichier exercice.txt existe mais les permissions sont incorrectes ($perms au lieu de 640)"
        exit 1
    fi
else
    echo "Le fichier exercice.txt n'existe pas"
    exit 1
fi
