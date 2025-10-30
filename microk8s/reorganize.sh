#!/bin/bash

# Script de réorganisation des exercices Killercoda
# Ordre logique pédagogique

set -e

BASEDIR="/home/fcrespin/Code/formation-microk8s/KILLERCODA/microk8s"
cd "$BASEDIR"

echo "🔄 Réorganisation des exercices Killercoda..."
echo ""

# Étape 1 : Renommer vers des noms temporaires pour éviter les collisions
echo "Étape 1/3 : Renommage vers noms temporaires..."

declare -A MAPPING=(
    ["01-deployer-nginx"]="temp-01-deployer-nginx"
    ["02-exposer-via-ingress"]="temp-04-exposer-via-ingress"
    ["03-ajouter-pvc"]="temp-05-ajouter-pvc"
    ["04-deployer-symfony"]="temp-10-deployer-symfony"
    ["05-configurer-hpa"]="temp-07-configurer-hpa"
    ["06-signoz-observabilite"]="temp-12-signoz-observabilite"
    ["07-configmaps-secrets"]="temp-02-configmaps-secrets"
    ["08-health-checks"]="temp-03-health-checks"
    ["09-resource-limits"]="temp-06-resource-limits"
    ["10-statefulsets"]="temp-08-statefulsets"
    ["11-jobs-cronjobs"]="temp-09-jobs-cronjobs"
    ["12-troubleshooting"]="temp-11-troubleshooting"
)

for old in "${!MAPPING[@]}"; do
    new="${MAPPING[$old]}"
    if [ -d "$old" ]; then
        echo "  $old → $new"
        mv "$old" "$new"
    fi
done

echo "✅ Étape 1 terminée"
echo ""

# Étape 2 : Renommer vers les noms finaux
echo "Étape 2/3 : Renommage vers noms finaux..."

for temp_dir in temp-*; do
    if [ -d "$temp_dir" ]; then
        final_name="${temp_dir#temp-}"
        echo "  $temp_dir → $final_name"
        mv "$temp_dir" "$final_name"
    fi
done

echo "✅ Étape 2 terminée"
echo ""

# Étape 3 : Vérification
echo "Étape 3/3 : Vérification de l'ordre..."
echo ""
echo "📚 Nouvel ordre des exercices :"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for dir in $(ls -1d */ | sort); do
    dir_name="${dir%/}"
    if [ -f "$dir_name/index.json" ]; then
        title=$(grep '"title"' "$dir_name/index.json" | head -1 | sed 's/.*"title": "\(.*\)".*/\1/')
        difficulty=$(grep '"difficulty"' "$dir_name/index.json" | head -1 | sed 's/.*"difficulty": "\(.*\)".*/\1/')
        time=$(grep '"time"' "$dir_name/index.json" | head -1 | sed 's/.*"time": "\(.*\)".*/\1/')
        printf "%-30s %-50s [%s, %s]\n" "$dir_name" "$title" "$difficulty" "$time"
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Réorganisation terminée avec succès !"
echo ""
echo "📊 Parcours pédagogique (total: ~6h15)"
echo "   • Beginner (01-06) : ~3h00"
echo "   • Intermediate (07-11) : ~2h35"
echo "   • Advanced (12) : ~0h40"
