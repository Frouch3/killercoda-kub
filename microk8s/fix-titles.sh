#!/bin/bash

# Script pour renommer les titres des exercices dans index.json

set -e

BASEDIR="/home/fcrespin/Code/formation-microk8s/KILLERCODA/microk8s"
cd "$BASEDIR"

echo "🔧 Correction des titres dans les fichiers index.json..."
echo ""

# Fonction pour mettre à jour le titre
update_title() {
    local dir=$1
    local new_number=$2
    local file="$dir/index.json"

    if [ -f "$file" ]; then
        # Extraire le titre actuel
        old_title=$(grep '"title"' "$file" | head -1 | sed 's/.*"title": "\(.*\)".*/\1/')

        # Remplacer "Exercice X" par "Exercice $new_number"
        new_title=$(echo "$old_title" | sed "s/Exercice [0-9.]*:/Exercice $new_number:/")

        # Mettre à jour le fichier
        sed -i "s|\"title\": \"$old_title\"|\"title\": \"$new_title\"|g" "$file"

        echo "✅ $dir: $old_title → $new_title"
    fi
}

# Mettre à jour chaque exercice
update_title "01-deployer-nginx" "1"
update_title "02-configmaps-secrets" "2"
update_title "03-health-checks" "3"
update_title "04-exposer-via-ingress" "4"
update_title "05-ajouter-pvc" "5"
update_title "06-resource-limits" "6"
update_title "07-configurer-hpa" "7"
update_title "08-statefulsets" "8"
update_title "09-jobs-cronjobs" "9"
update_title "10-deployer-symfony" "10"
update_title "11-troubleshooting" "11"
update_title "12-signoz-observabilite" "12"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📚 Titres après correction :"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for dir in */; do
    if [ -f "${dir}index.json" ]; then
        dir_name="${dir%/}"
        title=$(grep '"title"' "${dir}index.json" | head -1 | sed 's/.*"title": "\(.*\)".*/\1/')
        printf "%-30s %s\n" "$dir_name" "$title"
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Tous les titres ont été corrigés !"
