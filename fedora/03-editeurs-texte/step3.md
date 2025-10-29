# Étape 3 : Introduction à vim

## Qu'est-ce que vim ?

**vim** (Vi IMproved) est l'éditeur de texte le plus puissant et le plus répandu sur les systèmes Unix/Linux. Il est :
- **Présent partout** : sur tous les serveurs Linux
- **Très efficace** : une fois maîtrisé
- **Modal** : fonctionnement différent de nano

⚠️ vim a une courbe d'apprentissage plus raide que nano, mais la récompense en vaut la peine !

## La particularité de vim : Les modes

vim fonctionne avec différents **modes** :

1. **Mode NORMAL** (par défaut) : Navigation et commandes
2. **Mode INSERTION** : Édition de texte
3. **Mode VISUEL** : Sélection de texte
4. **Mode COMMANDE** : Commandes avancées

C'est cette différence qui déroute au début, mais qui rend vim si puissant !

## Ouvrir vim

```bash
cd ~
vim premier_vim.txt
```

vim s'ouvre. Vous êtes en **mode NORMAL**.

## Le piège classique : Comment quitter vim ?

C'est THE question de tous les débutants ! 😅

Pour quitter vim :
1. Appuyez sur `Esc` (pour être sûr d'être en mode NORMAL)
2. Tapez `:q` puis `Entrée`

Si vous avez modifié le fichier :
- `:q!` - Quitter **sans** sauvegarder
- `:wq` - **Sauvegarder** et quitter
- `:x` - Pareil que `:wq`

💡 **Astuce** : En cas de panique, tapez `Esc` puis `:q!` pour tout abandonner !

## Les trois modes essentiels

### Mode NORMAL (Navigation)

C'est le mode par défaut. Vous pouvez :
- Naviguer dans le texte
- Copier/coller/supprimer
- Chercher du texte

Pour revenir en mode NORMAL depuis n'importe où : **Appuyez sur `Esc`**

### Mode INSERTION (Édition)

Pour **écrire du texte**, vous devez passer en mode INSERTION.

Depuis le mode NORMAL, tapez :
- `i` - Insérer **avant** le curseur
- `a` - Insérer **après** le curseur (append)
- `o` - Insérer une **nouvelle ligne en dessous**
- `O` - Insérer une **nouvelle ligne au-dessus**

En bas de l'écran, vous voyez : `-- INSERT --`

Pour revenir en mode NORMAL : **Appuyez sur `Esc`**

### Mode COMMANDE

Pour exécuter des commandes, tapez `:` depuis le mode NORMAL.

En bas de l'écran apparaît `:` où vous pouvez taper vos commandes.

## Votre premier texte dans vim

Ouvrez vim :

```bash
vim test_vim.txt
```

**Suivez ces étapes précisément** :

1. Vous êtes en mode NORMAL
2. Appuyez sur `i` pour passer en INSERTION (vous voyez `-- INSERT --` en bas)
3. Tapez :
```
Bonjour vim !

Je suis en train d'apprendre vim.
C'est différent de nano mais très puissant.

Les modes :
- Normal : pour naviguer
- Insertion : pour écrire
- Commande : pour sauvegarder/quitter
```
4. Appuyez sur `Esc` pour revenir en mode NORMAL
5. Tapez `:w` puis `Entrée` pour sauvegarder (Write)
6. En bas vous voyez : `"test_vim.txt" 10L, XXX written`
7. Tapez `:q` puis `Entrée` pour quitter

Vérifiez :
```bash
cat test_vim.txt
```

Félicitations ! Vous avez créé votre premier fichier avec vim ! 🎉

## Navigation en mode NORMAL

Rouvrez le fichier :

```bash
vim test_vim.txt
```

En mode NORMAL, vous pouvez naviguer avec :

| Touche | Action |
|--------|--------|
| `h` | Gauche ← |
| `j` | Bas ↓ |
| `k` | Haut ↑ |
| `l` | Droite → |

💡 Les flèches du clavier fonctionnent aussi, mais les vrais vimmers utilisent hjkl !

Autres mouvements utiles :
- `w` - **W**ord : aller au mot suivant
- `b` - **B**ack : aller au mot précédent
- `0` - Aller au **début de la ligne**
- `$` - Aller à la **fin de la ligne**
- `gg` - Aller au **début du fichier**
- `G` - Aller à la **fin du fichier**
- `:10` - Aller à la **ligne 10**

Essayez ces commandes dans votre fichier !

## Les commandes essentielles de vim

### Sauvegarder et quitter

| Commande | Action |
|----------|--------|
| `:w` | Sauvegarder (Write) |
| `:q` | Quitter |
| `:wq` | Sauvegarder et quitter |
| `:x` | Sauvegarder et quitter (plus court) |
| `:q!` | Quitter sans sauvegarder (force) |
| `:w nom.txt` | Sauvegarder sous un nouveau nom |

### Passer en mode INSERTION

| Touche | Action |
|--------|--------|
| `i` | Insérer avant le curseur |
| `a` | Insérer après le curseur (append) |
| `I` | Insérer au début de la ligne |
| `A` | Insérer à la fin de la ligne |
| `o` | Nouvelle ligne en dessous |
| `O` | Nouvelle ligne au-dessus |

## Exercice pratique

### 1. Créer un nouveau fichier

```bash
vim exercice_vim.txt
```

### 2. Ajouter du contenu

1. Tapez `i` pour passer en mode INSERTION
2. Écrivez :
```
Ma liste de courses :
- Pain
- Lait
- Œufs
- Fromage
```
3. Appuyez sur `Esc`
4. Sauvegardez : `:w` puis `Entrée`

### 3. Ajouter des lignes

1. Appuyez sur `G` pour aller à la fin
2. Appuyez sur `o` (nouvelle ligne)
3. Ajoutez :
```
- Tomates
- Salade
```
4. Appuyez sur `Esc`
5. Sauvegardez : `:w` puis `Entrée`

### 4. Aller au début et ajouter un titre

1. Appuyez sur `gg` pour aller au début
2. Appuyez sur `O` (nouvelle ligne au-dessus)
3. Tapez :
```
=== COURSES DE LA SEMAINE ===
```
4. Appuyez sur `Esc`
5. Sauvegardez et quittez : `:wq` puis `Entrée`

### 5. Vérifier le résultat

```bash
cat exercice_vim.txt
```

## Aide dans vim

Pour obtenir de l'aide :
- `:help` - Aide générale
- `:help i` - Aide sur la commande `i`
- `:q` - Quitter l'aide

## Résumé - vim pour débutants

```bash
vim fichier.txt           # Ouvrir un fichier

# Modes
Esc                       # Retour en mode NORMAL
i                         # Mode INSERTION (avant curseur)
a                         # Mode INSERTION (après curseur)
o                         # Nouvelle ligne (en dessous)

# Navigation (mode NORMAL)
h j k l                   # Gauche, Bas, Haut, Droite
w / b                     # Mot suivant / précédent
0 / $                     # Début / Fin de ligne
gg / G                    # Début / Fin du fichier

# Sauvegarder et quitter (mode COMMANDE)
:w                        # Sauvegarder
:q                        # Quitter
:wq                       # Sauvegarder et quitter
:q!                       # Quitter sans sauvegarder
```

---

✅ Pratiquez ces bases de vim, puis cliquez sur "Continuer" pour découvrir des fonctionnalités plus avancées !
