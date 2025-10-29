# Étape 4 : Déplacer et renommer des fichiers

## Commande `mv` - Move (Déplacer/Renommer)

La commande `mv` a **deux usages** :
1. **Déplacer** un fichier vers un autre emplacement
2. **Renommer** un fichier

C'est la même commande pour les deux opérations !

### Syntaxe de base

```bash
mv source destination
```

## Usage 1 : Renommer un fichier

Pour renommer, la source et la destination sont dans le **même dossier** :

```bash
cd ~
# Créer un fichier
echo "Contenu test" > ancien_nom.txt

# Le renommer
mv ancien_nom.txt nouveau_nom.txt

# Vérifier
ls -l *.txt
```

Le fichier `ancien_nom.txt` n'existe plus, il s'appelle maintenant `nouveau_nom.txt`.

💡 **Important** : `mv` ne crée pas de copie, il **déplace vraiment** le fichier. L'original disparaît !

### Renommer un dossier

Ça marche aussi pour les dossiers :

```bash
mkdir ancien_dossier
mv ancien_dossier nouveau_dossier
ls -ld nouveau_dossier
```

## Usage 2 : Déplacer un fichier

Pour déplacer un fichier vers un autre dossier :

```bash
# Créer un fichier et un dossier de destination
echo "Document important" > document.txt
mkdir ~/documents

# Déplacer le fichier
mv document.txt ~/documents/

# Vérifier qu'il n'est plus là
ls document.txt         # Erreur : fichier introuvable

# Vérifier qu'il est bien dans documents
ls ~/documents/
```

Le fichier a été **déplacé**, pas copié. Il n'existe plus à son emplacement d'origine.

### Déplacer ET renommer en même temps

```bash
# Créer un fichier
echo "Test" > fichier.txt

# Le déplacer dans documents ET le renommer
mv fichier.txt ~/documents/nouveau_fichier.txt

# Vérifier
ls ~/documents/
```

Deux opérations en une seule commande ! ✨

## Déplacer plusieurs fichiers

Pour déplacer plusieurs fichiers, le dernier argument doit être un **dossier** :

```bash
# Créer des fichiers de test
touch test1.txt test2.txt test3.txt

# Les déplacer tous
mv test1.txt test2.txt test3.txt ~/documents/

# Vérifier
ls ~/documents/
```

### Avec des jokers

```bash
# Créer des fichiers
touch log1.txt log2.txt log3.txt

# Créer un dossier logs
mkdir ~/logs

# Déplacer tous les fichiers log*.txt
mv log*.txt ~/logs/

# Vérifier
ls ~/logs/
```

## Déplacer des dossiers

Contrairement à `cp`, **pas besoin de `-r`** pour déplacer un dossier :

```bash
# Créer un dossier avec du contenu
mkdir -p ancien_projet/src/code
touch ancien_projet/README.md

# Le déplacer (et le renommer)
mv ancien_projet nouveau_projet

# Vérifier
ls -R nouveau_projet/
```

Tout le contenu a été déplacé !

## Options utiles de `mv`

### Option `-i` : Mode interactif (confirmation)

Si la destination existe déjà, `-i` demande confirmation avant d'écraser :

```bash
# Créer deux fichiers
echo "Version 1" > fichier.txt
echo "Version 2" > fichier2.txt

# Essayer de renommer fichier2.txt en fichier.txt (qui existe)
mv -i fichier2.txt fichier.txt
```

Le système demande : `overwrite 'fichier.txt'?`

💡 **Toujours utiliser `-i`** pour les fichiers importants !

### Option `-v` : Mode verbeux

```bash
mv -v fichier.txt ~/documents/
```

Affiche : `'fichier.txt' -> '/root/documents/fichier.txt'`

### Option `-n` : Ne jamais écraser

```bash
mv -n fichier.txt destination.txt
```

Si `destination.txt` existe déjà, `mv` ne fait **rien** (ne déplace pas, ne demande pas confirmation).

### Combiner les options

```bash
mv -iv *.txt ~/documents/
```

Mode interactif et verbeux.

## Exercice pratique : Réorganiser des fichiers

### 1. Créer une structure désorganisée

```bash
cd ~
mkdir desordre
cd desordre

# Créer plein de fichiers en vrac
echo "Photo 1" > photo1.jpg
echo "Photo 2" > photo2.jpg
echo "Document A" > doc_a.txt
echo "Document B" > doc_b.txt
echo "Script" > script.sh
echo "Configuration" > config.conf
echo "Log" > application.log
```

### 2. Créer une structure organisée

```bash
# Créer des dossiers par catégorie
mkdir photos
mkdir documents
mkdir scripts
mkdir configs
mkdir logs
```

### 3. Organiser les fichiers

```bash
# Déplacer les photos
mv *.jpg photos/

# Déplacer les documents
mv *.txt documents/

# Déplacer les scripts
mv *.sh scripts/

# Déplacer les configs
mv *.conf configs/

# Déplacer les logs
mv *.log logs/

# Vérifier
ls -R
```

Tout est organisé ! 🎉

### 4. Renommer pour plus de clarté

```bash
# Renommer les photos avec un préfixe
cd photos
mv photo1.jpg vacances_2024_1.jpg
mv photo2.jpg vacances_2024_2.jpg

# Renommer les documents
cd ../documents
mv doc_a.txt rapport_janvier.txt
mv doc_b.txt rapport_fevrier.txt

# Vérifier
cd ..
ls -R
```

## Différences entre `cp` et `mv`

| Critère | `cp` (copier) | `mv` (déplacer) |
|---------|---------------|-----------------|
| Fichier original | **Reste** en place | **Disparaît** |
| Résultat | 2 fichiers identiques | 1 fichier à un nouvel emplacement |
| Espace disque | Utilise plus d'espace | Même espace |
| Dossiers | Nécessite `-r` | Pas besoin de `-r` |
| Vitesse | Plus lent (copie les données) | Très rapide (change juste le chemin) |

## Cas d'usage pratiques

### Renommer en masse

```bash
# Ajouter un préfixe à tous les fichiers .txt
for file in *.txt; do
    mv "$file" "backup_$file"
done
```

### Déplacer les fichiers modifiés récemment

```bash
# Créer un dossier pour les fichiers récents
mkdir ~/recents

# Déplacer les fichiers modifiés dans les dernières 24h
find . -mtime -1 -type f -exec mv {} ~/recents/ \;
```

### Organiser par extension

```bash
# Fonction pour créer un dossier par extension et déplacer les fichiers
for file in *.*; do
    ext="${file##*.}"
    mkdir -p "$ext"
    mv "$file" "$ext/"
done
```

## Bonnes pratiques

✅ **À FAIRE** :
- Utiliser `-i` pour éviter les écrasements accidentels
- Vérifier avec `ls` avant et après le déplacement
- Faire une copie de sauvegarde (`cp`) avant un `mv` important
- Utiliser des noms de fichiers explicites

❌ **À ÉVITER** :
- Déplacer sans vérifier la destination
- Écraser des fichiers importants
- Déplacer des fichiers système (dans /etc, /bin, etc.)
- Utiliser `mv` sur des fichiers en cours d'utilisation

## Résumé des commandes

```bash
mv ancien.txt nouveau.txt           # Renommer
mv fichier.txt ~/dossier/          # Déplacer
mv fichier.txt ~/dossier/new.txt   # Déplacer et renommer
mv -i fichier.txt dest.txt         # Avec confirmation
mv -v fichier.txt dest/            # Mode verbeux
mv -n fichier.txt dest.txt         # Ne jamais écraser
mv *.txt dossier/                  # Déplacer plusieurs fichiers
mv dossier/ nouveau_nom/           # Renommer un dossier
```

## Quand utiliser `cp` vs `mv` ?

- Utilisez **`cp`** quand vous voulez **garder l'original** (sauvegardes, duplications)
- Utilisez **`mv`** quand vous voulez **déplacer ou renommer** (organisation, nettoyage)

---

✅ Réorganisez vos fichiers de test, puis cliquez sur "Continuer" pour la dernière étape : la suppression sécurisée.
