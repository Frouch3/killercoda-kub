#!/bin/bash
if ! command -v nano &>/dev/null; then
    echo "❌ nano n'est pas disponible"
    exit 1
fi
echo "✅ Vous maîtrisez les fonctionnalités avancées de nano !"
exit 0
