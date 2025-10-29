#!/bin/bash
if ! command -v vim &>/dev/null; then
    echo "❌ vim n'est pas installé"
    exit 1
fi
echo "✅ Vous comprenez les bases de vim !"
exit 0
