# 🎨 Miniatures des Scénarios Killercoda

Ce dossier contient les miniatures (thumbnails) pour chaque scénario de la formation.

## 📁 Fichiers Disponibles

```
assets/
├── 00-formation-complete.svg      # Miniature générale de la formation
├── 01-deployer-nginx.svg          # Exercice 1 (Bleu)
├── 02-exposer-via-ingress.svg     # Exercice 2 (Vert)
├── 03-ajouter-pvc.svg             # Exercice 3 (Orange)
├── 04-deployer-symfony.svg        # Exercice 4 (Violet)
├── 05-configurer-hpa.svg          # Exercice 5 (Rouge)
├── 06-signoz-observabilite.svg    # Exercice 6 (Cyan)
├── convert-to-png.sh              # Script de conversion
└── README.md                      # Ce fichier
```

## 🎯 Caractéristiques des Miniatures

- **Format** : SVG (vectoriel) et PNG (après conversion)
- **Dimensions** : 1200x630 px (format Open Graph)
- **Style** : Moderne avec dégradés
- **Couleurs** : Une couleur unique par exercice
- **Contenu** :
  - Numéro de l'exercice (en grand, semi-transparent)
  - Titre complet
  - Niveau de difficulté (Débutant/Intermédiaire)
  - Durée estimée
  - Icône représentative
  - Éléments décoratifs (hexagones Kubernetes)

## 🔄 Conversion SVG → PNG

### Option 1 : Script Automatique

```bash
cd assets/
chmod +x convert-to-png.sh
./convert-to-png.sh
```

Les PNG seront générés dans `assets/png/`

### Option 2 : ImageMagick Manuel

```bash
# Installer ImageMagick
sudo apt install imagemagick  # Ubuntu/Debian
brew install imagemagick      # macOS

# Convertir un fichier
convert -background none 01-deployer-nginx.svg 01-deployer-nginx.png

# Convertir tous les fichiers
for f in *.svg; do convert -background none "$f" "png/${f%.svg}.png"; done
```

### Option 3 : Inkscape

```bash
# Installer Inkscape
sudo apt install inkscape

# Convertir avec meilleure qualité
inkscape 01-deployer-nginx.svg --export-filename=01-deployer-nginx.png --export-width=1200
```

### Option 4 : En Ligne (Sans installation)

1. Aller sur https://cloudconvert.com/svg-to-png
2. Uploader les fichiers SVG
3. Télécharger les PNG

## 📤 Utilisation sur Killercoda

### Méthode 1 : Via l'Interface Web

1. Aller dans votre scénario sur Killercoda
2. Section "Settings" → "Thumbnail"
3. Uploader le fichier PNG correspondant

### Méthode 2 : Via index.json

Ajouter dans le fichier `index.json` :

```json
{
  "title": "Exercice 1 : Déployer Nginx",
  "icon": "fa-cube",
  "image": "01-deployer-nginx.png",
  ...
}
```

Puis uploader le PNG dans le dossier du scénario.

## 🌐 Utilisation pour Réseaux Sociaux

Ces miniatures sont optimisées pour :

### Twitter Cards
```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://url/01-deployer-nginx.png">
```

### Open Graph (Facebook, LinkedIn)
```html
<meta property="og:image" content="https://url/01-deployer-nginx.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
```

### GitHub README
```markdown
![Exercice 1](./assets/01-deployer-nginx.svg)
```

## 🎨 Personnalisation

Pour modifier les miniatures :

1. **Éditeur SVG en ligne** : https://editor.method.ac/
2. **Inkscape** (gratuit) : https://inkscape.org/
3. **Figma** (gratuit) : https://figma.com/

### Palette de Couleurs

| Exercice | Couleur Primaire | Couleur Secondaire |
|----------|------------------|--------------------|
| 01 | `#0066CC` (Bleu) | `#004499` |
| 02 | `#00AA44` (Vert) | `#007733` |
| 03 | `#FF8800` (Orange) | `#CC6600` |
| 04 | `#8844CC` (Violet) | `#662299` |
| 05 | `#CC0044` (Rouge) | `#990033` |
| 06 | `#00CCCC` (Cyan) | `#009999` |

### Structure du SVG

```xml
<svg width="1200" height="630">
  <!-- Fond avec dégradé -->
  <defs>
    <linearGradient id="grad1">...</linearGradient>
  </defs>
  <rect fill="url(#grad1)"/>

  <!-- Éléments décoratifs -->
  <polygon>...</polygon>  <!-- Hexagones -->

  <!-- Contenu textuel -->
  <text>01</text>         <!-- Numéro -->
  <text>Exercice 1</text> <!-- Titre -->
  <text>Déployer Nginx</text>

  <!-- Tags -->
  <rect>...</rect>        <!-- Badge niveau -->
  <text>Débutant</text>

  <!-- Icône -->
  <circle>...</circle>
  <text>☸</text>          <!-- Symbole Kubernetes -->
</svg>
```

## 📊 Aperçu

### Formation Complète
![Formation](./00-formation-complete.svg)

### Exercice 1 - Déployer Nginx
![Exercice 1](./01-deployer-nginx.svg)

### Exercice 2 - Exposer via Ingress
![Exercice 2](./02-exposer-via-ingress.svg)

### Exercice 3 - Stockage Persistant
![Exercice 3](./03-ajouter-pvc.svg)

### Exercice 4 - Symfony + PostgreSQL
![Exercice 4](./04-deployer-symfony.svg)

### Exercice 5 - Autoscaling HPA
![Exercice 5](./05-configurer-hpa.svg)

### Exercice 6 - Observabilité Signoz
![Exercice 6](./06-signoz-observabilite.svg)

## 💡 Conseils

- **Garder les SVG** : Ils sont modifiables et sans perte de qualité
- **Optimiser les PNG** : Utiliser https://tinypng.com/ pour réduire la taille
- **Cohérence visuelle** : Garder le même style pour tous les exercices
- **Accessibilité** : S'assurer que le texte est lisible (bon contraste)

## 🔗 Liens Utiles

- **Killercoda Docs** : https://killercoda.com/creators/documentation
- **SVG Optimizer** : https://jakearchibald.github.io/svgomg/
- **Color Palette** : https://coolors.co/
- **Icons** : https://emojipedia.org/

---

**Questions ?** Ouvrir une issue sur le repo GitHub.
