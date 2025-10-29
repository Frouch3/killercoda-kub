# Étape 4 : Éditer avec vim - Commandes avancées

## Supprimer du texte en mode NORMAL

En mode NORMAL, vim offre des commandes puissantes pour supprimer :

| Commande | Action |
|----------|--------|
| `x` | Supprimer le caractère sous le curseur |
| `dd` | Supprimer la ligne entière |
| `dw` | Supprimer un mot (**d**elete **w**ord) |
| `d$` | Supprimer jusqu'à la fin de la ligne |
| `d0` | Supprimer jusqu'au début de la ligne |
| `5dd` | Supprimer 5 lignes |

Ouvrez un fichier pour pratiquer :

```bash
vim suppression.txt
```

Mode INSERTION (`i`), tapez :
```
Ligne à garder
Ligne à supprimer
Encore une ligne
Cette ligne aussi
Ligne importante
```

Revenez en mode NORMAL (`Esc`), puis :
- Placez le curseur sur "Ligne à supprimer"
- Tapez `dd` - La ligne disparaît !

## Copier et coller (Yank et Put)

| Commande | Action |
|----------|--------|
| `yy` | Copier la ligne (**y**ank) |
| `yw` | Copier un mot |
| `y$` | Copier jusqu'à la fin de ligne |
| `p` | Coller après le curseur (**p**ut) |
| `P` | Coller avant le curseur |
| `5yy` | Copier 5 lignes |

**Exercice** :
1. Placez le curseur sur une ligne
2. Tapez `yy` pour copier
3. Déplacez-vous avec `j` ou `k`
4. Tapez `p` pour coller

## Annuler et refaire

| Commande | Action |
|----------|--------|
| `u` | Annuler (**u**ndo) |
| `Ctrl+r` | Refaire (**r**edo) |
| `U` | Annuler tous les changements sur la ligne |

Très pratique si vous faites une erreur !

## Rechercher du texte

En mode NORMAL :
- `/motclé` - Rechercher "motclé" vers le bas
- `?motclé` - Rechercher vers le haut
- `n` - Occurrence suivante (**n**ext)
- `N` - Occurrence précédente

**Exemple** :
```bash
vim test_vim.txt
```

En mode NORMAL :
1. Tapez `/vim` puis `Entrée`
2. Le curseur va sur le premier "vim"
3. Tapez `n` pour aller au suivant
4. Tapez `N` pour revenir au précédent

## Remplacer du texte

### Remplacer un caractère

- `r` + caractère - Remplace le caractère sous le curseur

Exemple : placez le curseur sur un "a", tapez `re` → le "a" devient "e"

### Remplacer avec substitution

En mode COMMANDE :
- `:s/ancien/nouveau/` - Remplace sur la ligne actuelle
- `:s/ancien/nouveau/g` - Remplace **t**out sur la ligne (global)
- `:%s/ancien/nouveau/g` - Remplace dans **t**out le fichier
- `:%s/ancien/nouveau/gc` - Remplace avec confirmation

**Exercice** :
```bash
vim remplacement.txt
```

Mode INSERTION, tapez :
```
Linux est génial
Linux est puissant
J'aime Linux
Vive Linux !
```

Mode NORMAL, puis :
- `:%s/Linux/GNU\/Linux/g` puis `Entrée`
- Tous les "Linux" deviennent "GNU/Linux" !

## Mode VISUEL - Sélection de texte

Le mode VISUEL permet de sélectionner du texte :

| Commande | Action |
|----------|--------|
| `v` | Mode visuel caractère |
| `V` | Mode visuel ligne |
| `Ctrl+v` | Mode visuel bloc |

**Utilisation** :
1. Mode NORMAL : placez le curseur
2. Tapez `v` pour commencer la sélection
3. Déplacez le curseur (hjkl ou flèches)
4. Le texte se sélectionne
5. Opérations possibles :
   - `d` - Supprimer la sélection
   - `y` - Copier la sélection
   - `>` - Indenter
   - `<` - Désindenter

**Exercice - Sélectionner et supprimer** :
1. Mode NORMAL
2. Tapez `v`
3. Déplacez avec `l` pour sélectionner des caractères
4. Tapez `d` pour supprimer

**Exercice - Sélectionner des lignes** :
1. Mode NORMAL
2. Tapez `V` (maj+v)
3. Déplacez avec `j` pour sélectionner des lignes
4. Tapez `y` pour copier
5. Tapez `p` pour coller

## Indentation

| Commande | Action |
|----------|--------|
| `>>` | Indenter la ligne |
| `<<` | Désindenter la ligne |
| `5>>` | Indenter 5 lignes |
| `gg=G` | Ré-indenter tout le fichier |

## Numéros de ligne

Pour afficher les numéros de ligne :
- `:set number` ou `:set nu`
- `:set nonumber` ou `:set nonu` pour les cacher

Aller à une ligne spécifique :
- `:25` - Aller à la ligne 25
- `25G` - Pareil

## Exercice pratique complet

### 1. Créer un script

```bash
vim mon_script.sh
```

Mode INSERTION (`i`), tapez :
```bash
#!/bin/bash
# Mon premier script

echo "Bonjour !"
echo "Bienvenue dans vim"
echo "C'est un editeur puissant"

# Afficher la date
date

# Afficher qui je suis
whoami
```

### 2. Corrections avec vim

Mode NORMAL (`Esc`), puis :

**Ajouter une ligne** :
- Allez sur la ligne `echo "Bonjour !"`
- Tapez `o` pour une nouvelle ligne
- Tapez `echo "Début du script"`
- `Esc`

**Dupliquer une ligne** :
- Allez sur `echo "Bienvenue dans vim"`
- Tapez `yy` puis `p`
- La ligne est dupliquée !

**Supprimer la ligne dupliquée** :
- Tapez `dd`

**Remplacer "editeur" par "éditeur"** :
- `:%s/editeur/éditeur/g` puis `Entrée`

**Ajouter des commentaires** :
- Allez au début d'une ligne `echo`
- Tapez `I` (mode insertion au début)
- Tapez `# `
- `Esc`

### 3. Sauvegarder et rendre exécutable

- `:wq` pour sauvegarder et quitter

```bash
chmod +x mon_script.sh
./mon_script.sh
```

## Configuration de vim

Créez un fichier `~/.vimrc` pour personnaliser vim :

```bash
vim ~/.vimrc
```

Ajoutez :
```vim
" Configuration vim personnalisée
set number              " Numéros de ligne
set autoindent          " Indentation automatique
set tabstop=4           " Taille des tabs
set shiftwidth=4        " Taille de l'indentation
set expandtab           " Convertir tabs en espaces
syntax on               " Coloration syntaxique
set hlsearch            " Surligner les résultats de recherche
set ignorecase          " Recherche insensible à la casse
set mouse=a             " Activer la souris
```

Sauvegardez (`:wq`). Maintenant ouvrez n'importe quel fichier :
```bash
vim test.txt
```

Les numéros de ligne s'affichent automatiquement !

## Résumé des commandes avancées

```bash
# Suppression (mode NORMAL)
x                   # Supprimer caractère
dd                  # Supprimer ligne
dw                  # Supprimer mot
5dd                 # Supprimer 5 lignes

# Copier/Coller
yy                  # Copier ligne
yw                  # Copier mot
p                   # Coller après
P                   # Coller avant

# Annuler/Refaire
u                   # Annuler
Ctrl+r              # Refaire

# Recherche
/motclé             # Rechercher
n / N               # Suivant / Précédent

# Remplacement
:s/ancien/nouveau/g         # Ligne actuelle
:%s/ancien/nouveau/g        # Tout le fichier
:%s/ancien/nouveau/gc       # Avec confirmation

# Mode visuel
v                   # Sélection caractères
V                   # Sélection lignes
Ctrl+v              # Sélection bloc

# Indentation
>>                  # Indenter
<<                  # Désindenter
gg=G                # Ré-indenter tout

# Divers
:set number         # Afficher numéros de ligne
:25                 # Aller ligne 25
```

---

✅ Maîtrisez ces commandes avec de la pratique, puis cliquez sur "Continuer" !
