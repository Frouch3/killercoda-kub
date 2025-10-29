#!/bin/bash

# Vérifier que le répertoire /home/collaboration existe avec les bonnes permissions
if [ -d "/home/collaboration" ]; then
    perms=$(stat -c "%a" "/home/collaboration" 2>/dev/null)
    owner=$(stat -c "%U" "/home/collaboration" 2>/dev/null)
    group=$(stat -c "%G" "/home/collaboration" 2>/dev/null)

    if [ "$perms" = "770" ] && [ "$owner" = "root" ] && [ "$group" = "developpeurs" ]; then
        echo "Répertoire /home/collaboration correctement configuré"
        exit 0
    else
        echo "Configuration incorrecte : perms=$perms (attendu 770), owner=$owner (attendu root), group=$group (attendu developpeurs)"
        exit 1
    fi
else
    echo "Le répertoire /home/collaboration n'existe pas"
    exit 1
fi
