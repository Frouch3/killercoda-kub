# 📁 Index des Assets - Formation Microk8s

Ce dossier contient tous les assets visuels pour les scénarios Killercoda.

## 📂 Structure

```
assets/
├── 📄 Index & Documentation
│   ├── INDEX.md                    ← Ce fichier
│   ├── README.md                   ← Guide complet d'utilisation
│   └── GALLERY.md                  ← Galerie visuelle avec aperçus
│
├── 🎨 Miniatures SVG (7 fichiers)
│   ├── 00-formation-complete.svg   ← Miniature générale (3 KB)
│   ├── 01-deployer-nginx.svg       ← Exercice 1 - Bleu (2.1 KB)
│   ├── 02-exposer-via-ingress.svg  ← Exercice 2 - Vert (1.9 KB)
│   ├── 03-ajouter-pvc.svg          ← Exercice 3 - Orange (1.9 KB)
│   ├── 04-deployer-symfony.svg     ← Exercice 4 - Violet (1.9 KB)
│   ├── 05-configurer-hpa.svg       ← Exercice 5 - Rouge (1.9 KB)
│   └── 06-signoz-observabilite.svg ← Exercice 6 - Cyan (1.9 KB)
│
├── 🛠️ Scripts (4 fichiers)
│   ├── convert-to-png.sh           ← Conversion SVG → PNG
│   ├── update-scenarios.sh         ← Copie images dans scénarios
│   └── create-custom-thumbnail.sh  ← Générateur de miniatures
│
└── 🌐 Prévisualisation
    └── preview.html                ← Galerie HTML interactive
```

## 🎯 Fichiers Principaux

### Miniatures SVG

| Fichier | Exercice | Couleur | Taille |
|---------|----------|---------|--------|
| `00-formation-complete.svg` | Vue d'ensemble | Bleu Kubernetes | 3.0 KB |
| `01-deployer-nginx.svg` | Déployer Nginx | Bleu | 2.1 KB |
| `02-exposer-via-ingress.svg` | Exposer via Ingress | Vert | 1.9 KB |
| `03-ajouter-pvc.svg` | Stockage Persistant | Orange | 1.9 KB |
| `04-deployer-symfony.svg` | Symfony + PostgreSQL | Violet | 1.9 KB |
| `05-configurer-hpa.svg` | Autoscaling HPA | Rouge | 1.9 KB |
| `06-signoz-observabilite.svg` | Observabilité Signoz | Cyan | 1.9 KB |

**Total SVG** : 15.5 KB (très léger !)

### Scripts Utilitaires

| Script | Description | Usage |
|--------|-------------|-------|
| `convert-to-png.sh` | Convertit tous les SVG en PNG | `./convert-to-png.sh` |
| `update-scenarios.sh` | Copie les PNG dans chaque scénario | `./update-scenarios.sh` |
| `create-custom-thumbnail.sh` | Crée une miniature personnalisée | Voir exemples ci-dessous |

### Documentation

| Fichier | Contenu |
|---------|---------|
| `README.md` | Guide complet : conversion, utilisation, personnalisation |
| `GALLERY.md` | Aperçu visuel de toutes les miniatures |
| `INDEX.md` | Ce fichier - index de tous les assets |

### Prévisualisation

| Fichier | Description |
|---------|-------------|
| `preview.html` | Galerie interactive HTML avec tous les visuels |

## 🚀 Quick Start

### 1. Prévisualiser les Miniatures

```bash
# Ouvrir la galerie HTML dans le navigateur
firefox preview.html
# ou
xdg-open preview.html
```

### 2. Convertir en PNG

```bash
# Convertir tous les SVG en PNG (nécessite ImageMagick)
./convert-to-png.sh

# Les PNG seront dans le dossier png/
ls -lh png/
```

### 3. Utiliser sur Killercoda

```bash
# Copier les PNG dans chaque scénario
./update-scenarios.sh

# Puis éditer manuellement chaque index.json et ajouter :
# "image": "01-deployer-nginx.png"
```

## 🎨 Créer une Miniature Personnalisée

### Exemple 1 : Exercice Avancé

```bash
./create-custom-thumbnail.sh \
  "Exercice 7" \
  "CI/CD avec GitLab" \
  "Avancé" \
  "60 min" \
  "#336699" \
  "#224488" \
  "🚀" \
  "07-cicd-gitlab.svg"
```

### Exemple 2 : Workshop

```bash
./create-custom-thumbnail.sh \
  "Workshop" \
  "Production Best Practices" \
  "Expert" \
  "2h" \
  "#990099" \
  "#660066" \
  "⚡" \
  "workshop-production.svg"
```

### Exemple 3 : Tutoriel Spécifique

```bash
./create-custom-thumbnail.sh \
  "Tutoriel" \
  "Helm Charts Avancés" \
  "Intermédiaire" \
  "45 min" \
  "#FF6600" \
  "#CC4400" \
  "📦" \
  "tuto-helm.svg"
```

## 📊 Statistiques

| Métrique | Valeur |
|----------|--------|
| **Miniatures créées** | 7 |
| **Scripts** | 3 |
| **Documentation** | 3 fichiers |
| **Taille totale** | ~68 KB |
| **Formats** | SVG (source) + PNG (après conversion) |
| **Dimensions** | 1200 x 630 px |
| **Couleurs uniques** | 6 (+ 1 pour la formation) |

## 🎨 Palette de Couleurs

```css
/* Formation Complète */
--color-formation: #326CE5 → #1a4d9f

/* Niveau Débutant */
--color-ex1: #0066CC → #004499  /* Bleu - Nginx */
--color-ex2: #00AA44 → #007733  /* Vert - Ingress */
--color-ex3: #FF8800 → #CC6600  /* Orange - PVC */

/* Niveau Intermédiaire */
--color-ex4: #8844CC → #662299  /* Violet - Symfony */
--color-ex5: #CC0044 → #990033  /* Rouge - HPA */
--color-ex6: #00CCCC → #009999  /* Cyan - Signoz */
```

## 📱 Formats d'Export

Après conversion, vous obtiendrez :

- **SVG** (source) : Modifiable, vectoriel, léger
- **PNG** (1200x630) : Pour Killercoda, réseaux sociaux
- **PNG** (autres tailles) : Personnalisable via scripts

### Tailles Recommandées

```bash
# Taille standard (Open Graph)
convert 01-deployer-nginx.svg -resize 1200x630 output.png

# Version carrée (Instagram)
convert 01-deployer-nginx.svg -resize 1200x1200 output-square.png

# Version miniature
convert 01-deployer-nginx.svg -resize 400x400 output-thumb.png
```

## 🔗 Liens Utiles

- **Éditeur SVG en ligne** : https://editor.method.ac/
- **Convertisseur en ligne** : https://cloudconvert.com/svg-to-png
- **Optimiseur SVG** : https://jakearchibald.github.io/svgomg/
- **Palette de couleurs** : https://coolors.co/
- **Emojis** : https://emojipedia.org/

## 📝 Checklist Publication

- [ ] Créer les miniatures SVG
- [ ] Convertir en PNG (`./convert-to-png.sh`)
- [ ] Copier dans scénarios (`./update-scenarios.sh`)
- [ ] Mettre à jour les `index.json`
- [ ] Tester sur Killercoda (preview)
- [ ] Publier les scénarios
- [ ] Vérifier l'affichage des miniatures

## 💡 Astuces

1. **Garder les SVG** : Toujours éditer les SVG, pas les PNG
2. **Versions multiples** : Créer des variantes (dark mode, langues, etc.)
3. **Optimisation** : Compresser les PNG avec TinyPNG avant upload
4. **Cohérence** : Utiliser le même style pour tous les exercices
5. **Accessibilité** : Vérifier le contraste des couleurs

## 🐛 Troubleshooting

### ImageMagick n'est pas installé
```bash
# Ubuntu/Debian
sudo apt install imagemagick

# macOS
brew install imagemagick

# Fedora
sudo dnf install ImageMagick
```

### Erreur de conversion
```bash
# Vérifier la version
convert --version

# Tester avec un fichier
convert 01-deployer-nginx.svg test.png
file test.png
```

### Les PNG sont trop grands
```bash
# Compresser avec optipng
optipng -o7 *.png

# Ou avec pngquant
pngquant --quality=80-90 *.png
```

## 📞 Support

Questions ou problèmes ?
- Ouvrir une issue sur GitHub
- Consulter le README.md
- Voir la documentation Killercoda

---

**📅 Dernière mise à jour** : Octobre 2024
**👤 Auteur** : Formation Microk8s
**📄 Licence** : Open source - Réutilisable librement
