#!/bin/bash

# Script pour convertir les SVG en PNG
# Nécessite ImageMagick ou Inkscape

echo "🎨 Conversion des miniatures SVG en PNG..."
echo ""

# Vérifier si ImageMagick est installé
if command -v convert &> /dev/null; then
    CONVERTER="imagemagick"
    echo "✅ ImageMagick détecté"
elif command -v inkscape &> /dev/null; then
    CONVERTER="inkscape"
    echo "✅ Inkscape détecté"
else
    echo "❌ Erreur: ImageMagick ou Inkscape requis"
    echo ""
    echo "Installation:"
    echo "  Ubuntu/Debian: sudo apt install imagemagick"
    echo "  macOS:         brew install imagemagick"
    echo "  Fedora:        sudo dnf install ImageMagick"
    echo ""
    echo "Alternative en ligne: https://cloudconvert.com/svg-to-png"
    exit 1
fi

echo ""
echo "Conversion en cours..."
echo ""

# Créer le dossier de sortie
mkdir -p png

# Convertir chaque SVG
for svg_file in *.svg; do
    if [ -f "$svg_file" ]; then
        png_file="png/${svg_file%.svg}.png"

        if [ "$CONVERTER" = "imagemagick" ]; then
            # ImageMagick (plus simple)
            convert -background none -size 1200x630 "$svg_file" "$png_file"
        else
            # Inkscape (meilleure qualité)
            inkscape "$svg_file" --export-filename="$png_file" --export-width=1200 --export-height=630
        fi

        if [ $? -eq 0 ]; then
            echo "✅ $svg_file → $png_file"
        else
            echo "❌ Erreur lors de la conversion de $svg_file"
        fi
    fi
done

echo ""
echo "🎉 Conversion terminée!"
echo ""
echo "Fichiers PNG disponibles dans: $(pwd)/png/"
echo ""
echo "Pour utiliser sur Killercoda:"
echo "1. Uploader les PNG dans votre scénario"
echo "2. Ajouter dans index.json:"
echo '   "icon": "fa-cube"'
echo '   "image": "01-deployer-nginx.png"'
echo ""
