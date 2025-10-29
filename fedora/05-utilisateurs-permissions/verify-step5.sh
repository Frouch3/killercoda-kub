#!/bin/bash

# Vérifier que le fichier /etc/test_sudo.conf existe avec les bonnes permissions
if [ -f "/etc/test_sudo.conf" ]; then
    perms=$(stat -c "%a" "/etc/test_sudo.conf" 2>/dev/null)
    if [ "$perms" = "644" ]; then
        echo "Fichier /etc/test_sudo.conf créé avec les bonnes permissions"
        exit 0
    else
        echo "Le fichier existe mais les permissions sont incorrectes ($perms au lieu de 644)"
        exit 1
    fi
else
    echo "Le fichier /etc/test_sudo.conf n'existe pas"
    exit 1
fi
