# Étape 1 : Découvrir nano

## Qu'est-ce que nano ?

**nano** est un éditeur de texte simple et intuitif, parfait pour débuter sous Linux. Tous les raccourcis sont affichés en bas de l'écran, vous ne serez jamais perdu !

## Ouvrir nano

Pour ouvrir un fichier existant ou en créer un nouveau :

```bash
nano mon_fichier.txt
```

Si le fichier n'existe pas, nano le créera quand vous sauvegarderez.

## L'interface de nano

Lançons nano pour découvrir son interface :

```bash
cd ~
nano premier_test.txt
```

Vous voyez :
- **En haut** : Nom du fichier et informations
- **Au centre** : Zone d'édition (votre curseur clignote ici)
- **En bas** : Liste des raccourcis disponibles

💡 Le symbole `^` signifie la touche `Ctrl`. Donc `^X` = `Ctrl+X`

## Les raccourcis essentiels de nano

Voici les commandes affichées en bas :

| Raccourci | Action |
|-----------|--------|
| `Ctrl+O` | **S**auvegarder (Write **O**ut) |
| `Ctrl+X` | **Q**uitter nano |
| `Ctrl+G` | Afficher l'**a**ide complète |
| `Ctrl+K` | **C**ouper une ligne |
| `Ctrl+U` | **C**oller la ligne coupée |
| `Ctrl+W` | **R**echercher du texte |
| `Ctrl+\` | Remplacer du texte |
| `Ctrl+_` | Aller à une ligne spécifique |

## Votre premier texte dans nano

Dans nano qui est ouvert, **tapez du texte** :

```
Bienvenue dans nano !

Ceci est mon premier fichier édité avec nano.
Je peux taper librement comme dans un éditeur normal.

Les raccourcis sont affichés en bas.
C'est très pratique pour ne pas les oublier !
```

Utilisez les flèches du clavier pour vous déplacer dans le texte.

## Sauvegarder votre fichier

1. Appuyez sur `Ctrl+O` (Write Out = sauvegarder)
2. nano demande confirmation du nom : `File Name to Write: premier_test.txt`
3. Appuyez sur `Entrée` pour confirmer
4. En bas, vous voyez : `[ Wrote X lines ]` - c'est sauvegardé ! ✅

## Quitter nano

1. Appuyez sur `Ctrl+X` pour quitter
2. Si vous avez des modifications non sauvegardées, nano demande :
   - `Save modified buffer?` (Sauvegarder les modifications ?)
   - Tapez `Y` (yes) pour sauvegarder
   - Tapez `N` (no) pour abandonner les changements

Vous êtes de retour dans le terminal !

## Vérifier votre fichier

```bash
cat premier_test.txt
```

Vous voyez le texte que vous avez écrit. Félicitations ! 🎉

## Rouvrir un fichier existant

```bash
nano premier_test.txt
```

Le fichier s'ouvre avec le contenu précédent. Vous pouvez le modifier et sauvegarder à nouveau.

## Exercice pratique

### 1. Créer un fichier de notes

```bash
nano mes_notes.txt
```

Tapez :
```
Liste de mes tâches Linux :

1. Apprendre nano - En cours
2. Apprendre vim - À faire
3. Éditer des fichiers de config - À faire
4. Devenir expert Linux - Objectif final !

Notes importantes :
- Ctrl+O pour sauvegarder
- Ctrl+X pour quitter
- nano est facile à utiliser
```

Sauvegardez avec `Ctrl+O` puis `Entrée`, quittez avec `Ctrl+X`.

### 2. Modifier le fichier

```bash
nano mes_notes.txt
```

- Déplacez-vous avec les flèches
- Ajoutez une nouvelle ligne à la fin
- Modifiez "En cours" en "Terminé ✓"
- Sauvegardez et quittez

### 3. Vérifier les modifications

```bash
cat mes_notes.txt
```

Vos modifications sont bien enregistrées !

## Créer un fichier multi-lignes rapidement

```bash
nano recette.txt
```

Tapez une recette simple :
```
Recette de pâtes carbonara

Ingrédients :
- 400g de pâtes
- 200g de lardons
- 4 œufs
- 100g de parmesan
- Sel, poivre

Préparation :
1. Cuire les pâtes al dente
2. Faire revenir les lardons
3. Mélanger œufs et parmesan
4. Mélanger le tout hors du feu
5. Servir immédiatement !
```

Sauvegardez et quittez.

## Astuces nano

💡 **Navigation rapide** :
- `Ctrl+A` : Aller au début de la ligne
- `Ctrl+E` : Aller à la fin de la ligne
- `Ctrl+Y` : Page précédente
- `Ctrl+V` : Page suivante

💡 **Édition** :
- `Ctrl+K` : Couper la ligne actuelle
- `Ctrl+U` : Coller
- `Ctrl+K` plusieurs fois : couper plusieurs lignes
- `Alt+6` : Copier (sans couper)

💡 **Numérotation des lignes** :
```bash
nano -l fichier.txt
```
L'option `-l` affiche les numéros de ligne.

## Résumé des commandes nano

```bash
nano fichier.txt          # Ouvrir/créer un fichier
nano -l fichier.txt       # Avec numéros de ligne

# Dans nano :
Ctrl+O                    # Sauvegarder
Ctrl+X                    # Quitter
Ctrl+K                    # Couper ligne
Ctrl+U                    # Coller
Ctrl+W                    # Rechercher
Ctrl+\                    # Remplacer
Ctrl+G                    # Aide
```

---

✅ Créez et modifiez quelques fichiers avec nano, puis cliquez sur "Continuer" pour découvrir des fonctionnalités avancées.
