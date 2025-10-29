#!/bin/bash
if ! command -v apt &>/dev/null; then
    echo "❌ apt n'est pas disponible"
    exit 1
fi
echo "✅ Étape validée !"
exit 0
