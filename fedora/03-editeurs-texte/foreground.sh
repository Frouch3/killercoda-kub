#!/bin/bash
echo "⏳ Préparation de l'environnement..."
while [ ! -f /root/.setup_complete ]; do
    sleep 1
done
source /root/.bash_profile
echo ""
echo "✅ Environnement prêt !"
echo ""
