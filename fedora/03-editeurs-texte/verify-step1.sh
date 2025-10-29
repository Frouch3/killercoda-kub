#!/bin/bash
HOME_DIR=$(eval echo ~$(whoami))
if ! command -v nano &>/dev/null; then
    echo "❌ nano n'est pas installé"
    exit 1
fi
if [ ! -f "$HOME_DIR/premier_test.txt" ] && [ ! -f "$HOME_DIR/mes_notes.txt" ]; then
    echo "❌ Aucun fichier créé avec nano trouvé"
    exit 1
fi
echo "✅ Vous savez utiliser nano !"
exit 0
