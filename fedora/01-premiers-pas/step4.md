# Étape 4 : Naviguer entre les dossiers

## La commande `cd` - Change Directory

Pour vous déplacer d'un dossier à un autre, utilisez la commande `cd` (change directory).

## Les différentes façons de naviguer

### 1. Navigation avec chemin absolu

Un **chemin absolu** commence toujours par `/` et part de la racine du système.

```bash
cd /var/log
pwd
```

Vous êtes maintenant dans `/var/log`, peu importe où vous étiez avant.

### 2. Navigation avec chemin relatif

Un **chemin relatif** part de votre position actuelle (sans `/` au début).

D'abord, retournez dans votre dossier personnel :

```bash
cd ~
```

Maintenant entrez dans le dossier `mon_espace` que vous avez créé :

```bash
cd mon_espace
pwd
```

Vous êtes maintenant dans `~/mon_espace`. Allons plus loin :

```bash
cd personnel/documents
pwd
```

Vous êtes maintenant dans `~/mon_espace/personnel/documents`.

### 3. Remonter d'un niveau avec `..`

Le symbole `..` représente le **dossier parent** (celui du dessus).

```bash
# Vous êtes dans ~/mon_espace/personnel/documents
cd ..
pwd
```

Vous êtes remonté dans `~/mon_espace/personnel`.

Remontez encore :

```bash
cd ..
pwd
```

Vous êtes maintenant dans `~/mon_espace`.

### 4. Remonter de plusieurs niveaux

Vous pouvez enchaîner les `..` :

```bash
cd personnel/documents
pwd
# Vous êtes dans ~/mon_espace/personnel/documents

cd ../..
pwd
# Vous êtes remonté de 2 niveaux : dans ~/mon_espace
```

### 5. Les raccourcis pratiques

| Raccourci | Signification |
|-----------|---------------|
| `~` | Votre dossier personnel |
| `.` | Le dossier actuel |
| `..` | Le dossier parent |
| `-` | Le dossier précédent |

Exemples :

```bash
# Retourner au dossier personnel
cd ~

# Aller dans /etc puis revenir au dossier précédent
cd /etc
pwd
cd -
pwd
```

💡 `cd -` vous ramène au dossier où vous étiez juste avant. Très pratique !

## Exercice pratique : Le parcours du combattant !

Faites ce parcours en utilisant les commandes apprises :

```bash
# 1. Allez dans votre dossier personnel
cd ~

# 2. Entrez dans mon_espace/professionnel/projets
cd mon_espace/professionnel/projets
pwd

# 3. Remontez d'un niveau (vers professionnel)
cd ..
pwd

# 4. Allez dans formations (dossier frère de projets)
cd formations
pwd

# 5. Revenez au dossier précédent (projets)
cd -
pwd

# 6. Remontez de 2 niveaux (vers mon_espace)
cd ../..
pwd

# 7. Allez dans personnel/images en un seul cd
cd personnel/images
pwd

# 8. Retournez au dossier personnel en une seule commande
cd ~
pwd
```

## Astuces pour naviguer plus vite

### 1. L'autocomplétion avec Tab

Au lieu de taper tout le nom d'un dossier, tapez les premières lettres et appuyez sur `Tab` :

```bash
cd mon_e[Tab]
# Devient automatiquement : cd mon_espace/
```

Si plusieurs dossiers commencent par les mêmes lettres, appuyez deux fois sur `Tab` pour voir toutes les options.

### 2. Voir où vous allez avant d'y aller

```bash
ls mon_espace/personnel
cd mon_espace/personnel
```

D'abord regardez ce qu'il y a, puis déplacez-vous.

### 3. cd sans argument = retour au dossier personnel

```bash
cd
# Équivaut à : cd ~
pwd
```

## Résumé des commandes

```bash
cd /chemin/absolu          # Aller à un emplacement précis
cd dossier                 # Aller dans un sous-dossier
cd ..                      # Remonter d'un niveau
cd ../..                   # Remonter de 2 niveaux
cd ~                       # Aller au dossier personnel
cd -                       # Retour au dossier précédent
cd                         # Retour au dossier personnel
pwd                        # Afficher la position actuelle
```

---

✅ Réalisez l'exercice du parcours du combattant, puis cliquez sur "Continuer" pour apprendre à supprimer des dossiers.
