#!/bin/bash

cd fedora

echo "🔄 Mise à jour des titres des scénarios..."
echo ""

# Scénario 1
sed -i '2s/.*/  "title": "1. Premiers pas avec Fedora Linux",/' 01-premiers-pas/index.json
echo "✅ 01-premiers-pas"

# Scénario 2
sed -i '2s/.*/  "title": "2. Manipulation de fichiers sous Fedora",/' 02-manipulation-fichiers/index.json
echo "✅ 02-manipulation-fichiers"

# Scénario 3
sed -i '2s/.*/  "title": "3. Éditeurs de texte sous Linux",/' 03-editeurs-texte/index.json
echo "✅ 03-editeurs-texte"

# Scénario 4
sed -i '2s/.*/  "title": "4. Gestion des paquets sous Linux",/' 04-gestion-paquets/index.json
echo "✅ 04-gestion-paquets"

# Scénario 5
sed -i '2s/.*/  "title": "5. Utilisateurs et permissions",/' 05-utilisateurs-permissions/index.json
echo "✅ 05-utilisateurs-permissions"

# Scénario 6
sed -i '2s/.*/  "title": "6. Processus et services",/' 06-processus-services/index.json
echo "✅ 06-processus-services"

# Scénario 7
sed -i '2s/.*/  "title": "7. Réseau de base",/' 07-reseau-base/index.json
echo "✅ 07-reseau-base"

# Scénario 8
sed -i '2s/.*/  "title": "8. Scripts et automatisation",/' 08-scripts-automatisation/index.json
echo "✅ 08-scripts-automatisation"

echo ""
echo "✅ Tous les titres ont été mis à jour avec la numérotation !"
