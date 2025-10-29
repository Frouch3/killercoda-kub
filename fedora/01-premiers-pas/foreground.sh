#!/bin/bash

# Script foreground - s'exécute dans le terminal visible de l'utilisateur

# Attendre que le setup en arrière-plan soit terminé
echo "⏳ Préparation de l'environnement..."

# Attendre que le fichier .setup_complete soit créé
while [ ! -f /root/.setup_complete ]; do
    sleep 1
done

# Charger le profil bash
source /root/.bash_profile

# Afficher un message de démarrage
echo ""
echo "✅ Environnement prêt !"
echo ""
echo "Vous pouvez maintenant commencer l'exercice."
echo ""
