#!/bin/bash
HOME_DIR=$(eval echo ~$(whoami))
if [ ! -f "$HOME_DIR/.bashrc" ]; then
    echo "❌ Fichier .bashrc non trouvé"
    exit 1
fi
echo "✅ Vous savez éditer des fichiers de configuration !"
exit 0
