# Étape 3 : Copier des fichiers

## Commande `cp` - Copy (Copier)

La commande `cp` permet de copier des fichiers et des dossiers.

### Syntaxe de base

```bash
cp source destination
```

## Copier un fichier simple

Si vous avez créé les fichiers des étapes précédentes :

```bash
cd ~
# Copier un fichier dans le même dossier
cp citations.txt citations_backup.txt

# Vérifier
ls -l citations*
```

Vous avez maintenant deux fichiers identiques avec des noms différents.

### Copier vers un autre dossier

```bash
# Créer un dossier de destination
mkdir ~/sauvegardes

# Copier le fichier
cp citations.txt ~/sauvegardes/

# Vérifier
ls ~/sauvegardes/
```

Le fichier a été copié dans le dossier `sauvegardes` en gardant son nom.

### Copier et renommer en même temps

```bash
cp citations.txt ~/sauvegardes/mes_citations.txt

# Vérifier
ls ~/sauvegardes/
```

Le fichier est copié **et** renommé dans le même mouvement !

## Copier plusieurs fichiers

Pour copier plusieurs fichiers vers un dossier :

```bash
# Créer quelques fichiers de test
touch file1.txt file2.txt file3.txt

# Les copier tous vers sauvegardes
cp file1.txt file2.txt file3.txt ~/sauvegardes/

# Vérifier
ls ~/sauvegardes/
```

💡 **Important** : Quand vous copiez plusieurs fichiers, la **dernière destination doit être un dossier** !

### Utiliser les jokers (wildcards)

```bash
# Copier tous les fichiers .txt
cp *.txt ~/sauvegardes/

# Copier tous les fichiers qui commencent par "file"
cp file*.txt ~/sauvegardes/
```

## Copier des dossiers avec `-r`

Pour copier un **dossier et tout son contenu**, utilisez l'option `-r` (récursif) :

```bash
# Copier le dossier projet
cp -r ~/projet ~/projet_backup

# Vérifier
ls -la ~/projet_backup/
```

L'option `-r` copie le dossier et **tous ses sous-dossiers et fichiers**.

⚠️ **Sans `-r`, vous aurez une erreur** si vous essayez de copier un dossier !

## Options utiles de `cp`

### Option `-i` : Mode interactif (confirmation)

Si un fichier de destination existe déjà, `-i` demande confirmation avant d'écraser :

```bash
# Créer un fichier
echo "Version 1" > test.txt

# Le copier
cp test.txt test_backup.txt

# Modifier l'original
echo "Version 2" > test.txt

# Essayer de copier à nouveau avec -i
cp -i test.txt test_backup.txt
```

Le système vous demande : `overwrite 'test_backup.txt'?` Répondez `y` (yes) ou `n` (no).

💡 **Recommandation** : Utilisez toujours `-i` pour les fichiers importants !

### Option `-v` : Mode verbeux (afficher ce qui est fait)

```bash
cp -v citations.txt ~/sauvegardes/
```

La commande affiche : `'citations.txt' -> '/root/sauvegardes/citations.txt'`

C'est utile pour suivre ce qui se passe, surtout lors de copies multiples.

### Option `-p` : Préserver les attributs

```bash
cp -p fichier.txt copie.txt
```

L'option `-p` préserve :
- Les dates (création, modification)
- Les permissions
- Le propriétaire (si possible)

### Combiner plusieurs options

```bash
# Copie récursive, interactive et verbeuse
cp -riv ~/projet ~/projet_backup2
```

## Exercice pratique complet

### 1. Créez une structure de test

```bash
cd ~
mkdir -p atelier/documents
mkdir -p atelier/images
mkdir -p atelier/config

# Créer des fichiers dans documents
echo "Rapport 2024" > atelier/documents/rapport.txt
echo "Notes importantes" > atelier/documents/notes.txt

# Créer des fichiers dans config
echo "PORT=8080" > atelier/config/app.conf
echo "DEBUG=true" > atelier/config/dev.conf
```

### 2. Faites différentes copies

```bash
# Copier un fichier unique
cp atelier/documents/rapport.txt atelier/documents/rapport_backup.txt

# Copier tous les fichiers .txt d'un dossier à un autre
cp atelier/documents/*.txt atelier/images/

# Copier un dossier complet
cp -r atelier atelier_backup

# Vérifier la structure
ls -R atelier_backup/
```

### 3. Copie avec confirmation

```bash
# Créer une sauvegarde avec confirmation
mkdir ~/backup_important
cp -iv atelier/config/*.conf ~/backup_important/
```

### 4. Vérifier les copies

```bash
# Comparer les tailles
du -sh atelier
du -sh atelier_backup

# Vérifier le contenu
diff atelier/documents/rapport.txt atelier_backup/documents/rapport.txt
```

Si `diff` ne renvoie rien, c'est que les fichiers sont identiques ! ✅

## Bonnes pratiques de copie

✅ **À FAIRE** :
- Toujours vérifier avec `ls` avant de copier
- Utiliser `-i` pour éviter d'écraser des fichiers importants
- Faire des sauvegardes régulières avec des noms explicites
- Utiliser des noms de backup avec la date : `fichier_2024-10-29.txt`
- Tester vos copies avec `diff` ou `wc`

❌ **À ÉVITER** :
- Copier sans vérifier l'espace disque disponible (`df -h`)
- Écraser des fichiers importants sans backup
- Copier récursivement sans réfléchir (peut prendre beaucoup de place)

## Astuces avancées

### Copier avec date dans le nom

```bash
# Créer un backup avec la date d'aujourd'hui
cp important.txt important_$(date +%Y-%m-%d).txt
```

### Copier seulement si plus récent

```bash
cp -u source.txt destination.txt
```

L'option `-u` (update) ne copie que si le fichier source est plus récent que la destination.

## Résumé des commandes

```bash
cp source dest                      # Copier un fichier
cp -r dossier/ copie/              # Copier un dossier (récursif)
cp -i fichier dest                 # Avec confirmation
cp -v fichier dest                 # Mode verbeux
cp -p fichier dest                 # Préserver attributs
cp -riv dossier/ backup/           # Combinaison d'options
cp *.txt dossier/                  # Copier avec jokers
cp f1 f2 f3 dossier/              # Copier plusieurs fichiers
```

---

✅ Pratiquez les copies de fichiers et dossiers, puis cliquez sur "Continuer" pour apprendre à déplacer et renommer.
