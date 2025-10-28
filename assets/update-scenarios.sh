#!/bin/bash

# Script pour mettre à jour les index.json avec les miniatures
# Après avoir converti les SVG en PNG, ce script copie les images
# dans chaque dossier de scénario et met à jour le index.json

echo "🔄 Mise à jour des scénarios avec miniatures..."
echo ""

# Vérifier que les PNG existent
if [ ! -d "png" ]; then
    echo "❌ Erreur: Le dossier png/ n'existe pas"
    echo "💡 Exécutez d'abord: ./convert-to-png.sh"
    exit 1
fi

# Tableau des scénarios
declare -a scenarios=(
    "01-deployer-nginx"
    "02-exposer-via-ingress"
    "03-ajouter-pvc"
    "04-deployer-symfony"
    "05-configurer-hpa"
    "06-signoz-observabilite"
)

# Copier les images et mettre à jour index.json
for scenario in "${scenarios[@]}"; do
    scenario_dir="../$scenario"

    if [ ! -d "$scenario_dir" ]; then
        echo "⚠️  Scénario $scenario non trouvé, ignoré"
        continue
    fi

    png_file="png/${scenario}.png"

    if [ ! -f "$png_file" ]; then
        echo "⚠️  Image $png_file non trouvée, ignorée"
        continue
    fi

    # Copier l'image dans le dossier du scénario
    cp "$png_file" "$scenario_dir/"

    if [ $? -eq 0 ]; then
        echo "✅ Image copiée: $scenario_dir/${scenario}.png"
    else
        echo "❌ Erreur lors de la copie de l'image pour $scenario"
        continue
    fi

    # Note: La mise à jour automatique du JSON est complexe
    # Il vaut mieux le faire manuellement pour éviter d'écraser la config
    echo "   💡 Ajoutez manuellement dans index.json:"
    echo "      \"image\": \"${scenario}.png\","
    echo ""
done

echo ""
echo "🎉 Images copiées dans les scénarios!"
echo ""
echo "📝 Prochaines étapes:"
echo ""
echo "1. Éditer manuellement chaque index.json et ajouter:"
echo "   {"
echo "     \"title\": \"...\","
echo "     \"image\": \"XX-nom-scenario.png\",  ← Ajouter cette ligne"
echo "     ..."
echo "   }"
echo ""
echo "2. Uploader sur Killercoda:"
echo "   - Les fichiers .png sont maintenant dans chaque dossier de scénario"
echo "   - Killercoda les détectera automatiquement"
echo ""
echo "3. Alternative - Upload via l'interface web:"
echo "   - Aller dans Settings → Thumbnail"
echo "   - Uploader le PNG correspondant"
echo ""
