#!/bin/bash

# Vérification de l'étape 1 : Se repérer dans le système
# On vérifie simplement que l'utilisateur sait où il est

# Vérifier que pwd fonctionne
if ! pwd &>/dev/null; then
    echo "❌ Erreur : La commande 'pwd' ne fonctionne pas correctement"
    exit 1
fi

# Vérifier que ls fonctionne
if ! ls &>/dev/null; then
    echo "❌ Erreur : La commande 'ls' ne fonctionne pas correctement"
    exit 1
fi

# Vérifier que whoami fonctionne
if ! whoami &>/dev/null; then
    echo "❌ Erreur : La commande 'whoami' ne fonctionne pas correctement"
    exit 1
fi

echo "✅ Parfait ! Vous savez maintenant vous repérer dans le système."
exit 0
