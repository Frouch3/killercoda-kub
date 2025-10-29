# Étape 2 : Éditer avec nano - Techniques avancées

## Rechercher et remplacer du texte

### Rechercher

Ouvrez un fichier avec du contenu :

```bash
cd ~
nano mes_notes.txt
```

Pour **rechercher** un mot :
1. Appuyez sur `Ctrl+W`
2. Tapez le mot à rechercher (ex: "Linux")
3. Appuyez sur `Entrée`
4. Le curseur se déplace sur la première occurrence
5. Appuyez à nouveau sur `Ctrl+W` puis `Entrée` pour la suivante

### Remplacer

Pour **remplacer** du texte :
1. Appuyez sur `Ctrl+\` (backslash)
2. Tapez le texte à remplacer (ex: "À faire")
3. Appuyez sur `Entrée`
4. Tapez le nouveau texte (ex: "En cours")
5. Appuyez sur `Entrée`
6. nano demande pour chaque occurrence :
   - `Y` : Oui, remplacer
   - `N` : Non, passer
   - `A` : Remplacer **t**out (All)

## Couper, copier, coller

### Couper et coller des lignes

```bash
nano test_edition.txt
```

Tapez plusieurs lignes :
```
Ligne 1
Ligne 2
Ligne 3
Ligne 4
Ligne 5
```

**Couper une ligne** :
1. Placez le curseur sur "Ligne 3"
2. Appuyez sur `Ctrl+K`
3. La ligne disparaît (elle est dans le presse-papier)

**Coller** :
1. Déplacez le curseur où vous voulez coller
2. Appuyez sur `Ctrl+U`
3. La ligne est collée !

**Couper plusieurs lignes** :
1. Placez le curseur sur la première ligne
2. Appuyez plusieurs fois sur `Ctrl+K`
3. Toutes les lignes coupées sont dans le presse-papier
4. Collez-les avec `Ctrl+U`

### Copier sans couper

Pour **copier** une ligne sans la supprimer :
1. Placez le curseur sur la ligne
2. Appuyez sur `Alt+6` (ou `Alt+^` sur certains claviers)
3. La ligne est copiée
4. Collez avec `Ctrl+U`

## Sélectionner du texte

Pour sélectionner du texte précisément :

1. Placez le curseur au début de la sélection
2. Appuyez sur `Ctrl+^` (ou `Alt+A`)
3. Déplacez le curseur : le texte se sélectionne
4. Appuyez sur `Ctrl+K` pour couper la sélection
5. Ou `Alt+6` pour copier la sélection

## Aller à une ligne spécifique

Pour les fichiers longs, aller directement à une ligne :

```bash
# Créer un fichier avec 50 lignes
for i in {1..50}; do echo "Ligne numéro $i"; done > grand_fichier.txt

# Ouvrir avec numéros de ligne
nano -l grand_fichier.txt
```

Pour aller à la ligne 30 :
1. Appuyez sur `Ctrl+_` (underscore)
2. Tapez `30`
3. Appuyez sur `Entrée`
4. Le curseur saute à la ligne 30 !

## Annuler et refaire

- **Annuler** : `Alt+U` (Undo)
- **Refaire** : `Alt+E` (Redo)

Testez :
```bash
nano annulation.txt
```

Tapez du texte, puis :
1. Appuyez sur `Alt+U` : annule la dernière action
2. Appuyez sur `Alt+E` : refait l'action annulée

## Exercice pratique complet

### 1. Créer un fichier de configuration

```bash
nano app_config.txt
```

Tapez :
```
# Configuration de l'application

# Paramètres du serveur
PORT=8080
HOST=localhost
DEBUG=false

# Paramètres de la base de données
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USER=admin
DB_PASSWORD=changeme

# Paramètres de sécurité
SECRET_KEY=secret123
SESSION_TIMEOUT=3600
```

Sauvegardez avec `Ctrl+O`, `Entrée`.

### 2. Rechercher et remplacer

- Cherchez "localhost" : `Ctrl+W`, tapez "localhost", `Entrée`
- Remplacez tous les "localhost" par "127.0.0.1" : `Ctrl+\`, tapez "localhost", `Entrée`, tapez "127.0.0.1", `Entrée`, puis `A` (All)

### 3. Modifier plusieurs lignes

- Allez à la ligne des ports : `Ctrl+W`, cherchez "PORT"
- Changez `PORT=8080` en `PORT=3000`
- Changez `DB_PORT=5432` en `DB_PORT=3306`

### 4. Copier une section

- Allez sur la ligne `# Paramètres de sécurité`
- Coupez les 3 lignes suivantes : `Ctrl+K` trois fois
- Allez en haut du fichier : `Ctrl+Y` ou `Alt+\`
- Collez : `Ctrl+U`

### 5. Sauvegarder et quitter

`Ctrl+O`, `Entrée`, `Ctrl+X`

### 6. Vérifier le résultat

```bash
cat app_config.txt
```

## Éditer des fichiers avec sudo

Certains fichiers système nécessitent des droits administrateur :

```bash
sudo nano /etc/hosts
```

⚠️ **Attention** : Soyez prudent en éditant des fichiers système !

## Options utiles de nano

```bash
nano -l fichier.txt       # Afficher numéros de ligne
nano -m fichier.txt       # Activer la souris
nano -w fichier.txt       # Désactiver le retour à la ligne auto
nano +10 fichier.txt      # Ouvrir à la ligne 10
nano -B fichier.txt       # Créer une sauvegarde automatique
```

## Configuration personnalisée de nano

Vous pouvez personnaliser nano en créant `~/.nanorc` :

```bash
nano ~/.nanorc
```

Ajoutez :
```
set linenumbers          # Toujours afficher les numéros
set mouse                # Activer la souris
set autoindent           # Indentation automatique
set tabsize 4            # Taille des tabulations
set smooth               # Défilement fluide
```

Sauvegardez. Maintenant, ouvrez n'importe quel fichier :

```bash
nano test.txt
```

Les numéros de ligne s'affichent automatiquement !

## Astuces de productivité

### Indentation

- `Alt+}` : Indenter la ligne
- `Alt+{` : Désindenter la ligne

### Justification

- `Ctrl+J` : Justifier le paragraphe

### Statistiques

- `Alt+D` : Compter les mots, lignes, caractères

## Résumé des raccourcis avancés

```bash
# Recherche et remplacement
Ctrl+W              # Rechercher
Ctrl+\              # Remplacer

# Édition
Ctrl+K              # Couper ligne
Ctrl+U              # Coller
Alt+6               # Copier ligne
Ctrl+^              # Commencer sélection
Alt+U               # Annuler
Alt+E               # Refaire

# Navigation
Ctrl+_              # Aller à une ligne
Ctrl+A              # Début de ligne
Ctrl+E              # Fin de ligne
Alt+\               # Début du fichier
Alt+/               # Fin du fichier

# Affichage
Ctrl+G              # Aide complète
Alt+D               # Statistiques
```

---

✅ Pratiquez ces techniques d'édition, puis cliquez sur "Continuer" pour découvrir vim !
