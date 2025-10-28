#!/bin/bash

# Script pour créer une miniature personnalisée
# Usage: ./create-custom-thumbnail.sh "Titre" "Sous-titre" "Niveau" "Durée" "Couleur1" "Couleur2" "Emoji" "output.svg"

if [ $# -ne 8 ]; then
    echo "Usage: $0 <titre> <sous-titre> <niveau> <durée> <couleur1> <couleur2> <emoji> <output>"
    echo ""
    echo "Exemple:"
    echo "  $0 'Exercice 7' 'CI/CD avec GitLab' 'Avancé' '60 min' '#336699' '#224488' '🚀' 07-cicd-gitlab.svg"
    exit 1
fi

TITLE="$1"
SUBTITLE="$2"
LEVEL="$3"
DURATION="$4"
COLOR1="$5"
COLOR2="$6"
EMOJI="$7"
OUTPUT="$8"

# Extraire le numéro de l'exercice si présent
NUMBER=$(echo "$TITLE" | grep -oP '(?<=Exercice )\d+' || echo "")

cat > "$OUTPUT" <<EOF
<svg width="1200" height="630" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="customGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:${COLOR1};stop-opacity:1" />
      <stop offset="100%" style="stop-color:${COLOR2};stop-opacity:1" />
    </linearGradient>
  </defs>

  <rect width="1200" height="630" fill="url(#customGrad)"/>

  <polygon points="100,100 150,125 150,175 100,200 50,175 50,125" fill="#ffffff" opacity="0.1"/>
  <polygon points="1100,450 1150,475 1150,525 1100,550 1050,525 1050,475" fill="#ffffff" opacity="0.1"/>
  <polygon points="200,500 250,525 250,575 200,600 150,575 150,525" fill="#ffffff" opacity="0.15"/>

EOF

# Ajouter le numéro si présent
if [ ! -z "$NUMBER" ]; then
    cat >> "$OUTPUT" <<EOF
  <text x="100" y="200" font-family="Arial, sans-serif" font-size="180" font-weight="bold" fill="#ffffff" opacity="0.3">${NUMBER}</text>
EOF
fi

cat >> "$OUTPUT" <<EOF
  <text x="100" y="300" font-family="Arial, sans-serif" font-size="64" font-weight="bold" fill="#ffffff">
    ${TITLE}
  </text>

  <text x="100" y="370" font-family="Arial, sans-serif" font-size="52" fill="#ffffff">
    ${SUBTITLE}
  </text>

  <rect x="100" y="420" width="220" height="45" rx="22.5" fill="#ffffff" opacity="0.2"/>
  <text x="210" y="450" font-family="Arial, sans-serif" font-size="24" fill="#ffffff" text-anchor="middle">
    ${LEVEL}
  </text>

  <rect x="340" y="420" width="150" height="45" rx="22.5" fill="#ffffff" opacity="0.2"/>
  <text x="415" y="450" font-family="Arial, sans-serif" font-size="24" fill="#ffffff" text-anchor="middle">
    ${DURATION}
  </text>

  <circle cx="1050" cy="200" r="80" fill="#ffffff" opacity="0.2"/>
  <text x="1050" y="230" font-family="monospace" font-size="60" fill="#ffffff" text-anchor="middle">${EMOJI}</text>

  <text x="100" y="590" font-family="Arial, sans-serif" font-size="24" fill="#ffffff" opacity="0.7">
    Formation Microk8s • Killercoda Interactive
  </text>
</svg>
EOF

echo "✅ Miniature créée: $OUTPUT"
echo ""
echo "Aperçu:"
echo "  Titre:      $TITLE"
echo "  Sous-titre: $SUBTITLE"
echo "  Niveau:     $LEVEL"
echo "  Durée:      $DURATION"
echo "  Couleurs:   $COLOR1 → $COLOR2"
echo "  Icône:      $EMOJI"
echo ""
echo "Pour convertir en PNG:"
echo "  convert -background none $OUTPUT ${OUTPUT%.svg}.png"
echo ""
