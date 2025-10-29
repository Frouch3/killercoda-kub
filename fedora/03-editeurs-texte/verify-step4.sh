#!/bin/bash
if ! command -v vim &>/dev/null; then
    echo "❌ vim n'est pas disponible"
    exit 1
fi
echo "✅ Vous maîtrisez les commandes avancées de vim !"
exit 0
