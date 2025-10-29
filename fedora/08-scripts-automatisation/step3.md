# Étape 3 : Conditions et tests

## Introduction

Les **conditions** permettent à vos scripts de prendre des décisions et d'exécuter différents blocs de code selon les situations.

## Structure if

### Syntaxe de base

```bash
#!/bin/bash

if [ condition ]; then
    # Code si condition vraie
fi
```

### if-else

```bash
#!/bin/bash

age=18

if [ $age -ge 18 ]; then
    echo "Vous êtes majeur"
else
    echo "Vous êtes mineur"
fi
```

### if-elif-else

```bash
#!/bin/bash

note=15

if [ $note -ge 16 ]; then
    echo "Très bien"
elif [ $note -ge 14 ]; then
    echo "Bien"
elif [ $note -ge 12 ]; then
    echo "Assez bien"
elif [ $note -ge 10 ]; then
    echo "Passable"
else
    echo "Insuffisant"
fi
```

## Tests numériques

Opérateurs de comparaison :

| Opérateur | Signification |
|-----------|---------------|
| -eq | égal (equal) |
| -ne | différent (not equal) |
| -gt | supérieur (greater than) |
| -ge | supérieur ou égal (greater or equal) |
| -lt | inférieur (less than) |
| -le | inférieur ou égal (less or equal) |

### Exemples

```bash
#!/bin/bash

a=10
b=20

if [ $a -eq $b ]; then
    echo "a égal b"
fi

if [ $a -lt $b ]; then
    echo "a inférieur à b"
fi

if [ $a -ne $b ]; then
    echo "a différent de b"
fi
```

## Tests de chaînes

| Opérateur | Signification |
|-----------|---------------|
| = ou == | égal |
| != | différent |
| -z | chaîne vide (zero length) |
| -n | chaîne non vide (non-zero length) |
| < | inférieur (ordre alphabétique) |
| > | supérieur (ordre alphabétique) |

### Exemples

```bash
#!/bin/bash

nom="Alice"

if [ "$nom" = "Alice" ]; then
    echo "Bonjour Alice !"
fi

if [ -z "$nom" ]; then
    echo "Nom vide"
else
    echo "Nom : $nom"
fi

if [ -n "$nom" ]; then
    echo "Nom non vide"
fi
```

**Important** : Toujours mettre les variables entre guillemets pour éviter les erreurs si la variable est vide !

## Tests de fichiers

| Test | Signification |
|------|---------------|
| -e | existe (exist) |
| -f | fichier régulier (file) |
| -d | répertoire (directory) |
| -r | lisible (readable) |
| -w | modifiable (writable) |
| -x | exécutable |
| -s | non vide (size > 0) |
| -L | lien symbolique |

### Exemples

```bash
#!/bin/bash

fichier="/etc/passwd"

if [ -e "$fichier" ]; then
    echo "Le fichier existe"
fi

if [ -f "$fichier" ]; then
    echo "C'est un fichier régulier"
fi

if [ -r "$fichier" ]; then
    echo "Le fichier est lisible"
fi

if [ -d "/etc" ]; then
    echo "/etc est un répertoire"
fi
```

### Script de vérification

```bash
#!/bin/bash

read -p "Entrez un chemin : " chemin

if [ ! -e "$chemin" ]; then
    echo "N'existe pas"
elif [ -d "$chemin" ]; then
    echo "C'est un répertoire"
    ls -l "$chemin"
elif [ -f "$chemin" ]; then
    echo "C'est un fichier"
    wc -l "$chemin"
fi
```

## Opérateurs logiques

### ET logique (&&ou -a)

```bash
#!/bin/bash

age=25
permis="oui"

if [ $age -ge 18 ] && [ "$permis" = "oui" ]; then
    echo "Vous pouvez conduire"
fi

# Syntaxe alternative
if [ $age -ge 18 -a "$permis" = "oui" ]; then
    echo "Vous pouvez conduire"
fi
```

### OU logique (|| ou -o)

```bash
#!/bin/bash

jour="samedi"

if [ "$jour" = "samedi" ] || [ "$jour" = "dimanche" ]; then
    echo "C'est le week-end !"
fi

# Syntaxe alternative
if [ "$jour" = "samedi" -o "$jour" = "dimanche" ]; then
    echo "C'est le week-end !"
fi
```

### Négation (! ou)

```bash
#!/bin/bash

if [ ! -f "/fichier_inexistant" ]; then
    echo "Le fichier n'existe pas"
fi
```

## Double crochets [[ ]]

**[[ ]]** est une version améliorée de **[ ]** (bash uniquement) :

```bash
#!/bin/bash

nom="Alice"

# Pas besoin de guillemets
if [[ $nom = "Alice" ]]; then
    echo "Bonjour Alice"
fi

# Expressions régulières
if [[ $nom =~ ^A ]]; then
    echo "Le nom commence par A"
fi

# Wildcards
fichier="document.txt"
if [[ $fichier == *.txt ]]; then
    echo "Fichier texte"
fi
```

**Avantages de [[ ]]** :
- Pas besoin de quoter les variables
- Support des regex avec =~
- Support des wildcards
- Plus sûr

## Structure case

Pour plusieurs conditions sur une même variable :

```bash
#!/bin/bash

read -p "Entrez un nombre (1-3) : " choix

case $choix in
    1)
        echo "Vous avez choisi UN"
        ;;
    2)
        echo "Vous avez choisi DEUX"
        ;;
    3)
        echo "Vous avez choisi TROIS"
        ;;
    *)
        echo "Choix invalide"
        ;;
esac
```

### Avec motifs

```bash
#!/bin/bash

read -p "Entrez un fichier : " fichier

case $fichier in
    *.txt)
        echo "Fichier texte"
        ;;
    *.jpg|*.png|*.gif)
        echo "Fichier image"
        ;;
    *.sh)
        echo "Script shell"
        ;;
    *)
        echo "Type inconnu"
        ;;
esac
```

### Script de menu

```bash
#!/bin/bash

echo "=== Menu Principal ==="
echo "1. Afficher la date"
echo "2. Afficher les utilisateurs"
echo "3. Afficher l'espace disque"
echo "4. Quitter"
echo ""

read -p "Votre choix : " choix

case $choix in
    1)
        date
        ;;
    2)
        who
        ;;
    3)
        df -h
        ;;
    4)
        echo "Au revoir !"
        exit 0
        ;;
    *)
        echo "Choix invalide"
        exit 1
        ;;
esac
```

## Test avec commande [[

La syntaxe `(( ))` est pratique pour les tests arithmétiques :

```bash
#!/bin/bash

nombre=42

if (( nombre > 40 )); then
    echo "Nombre supérieur à 40"
fi

if (( nombre % 2 == 0 )); then
    echo "Nombre pair"
fi
```

## Opérateur ternaire

Bash n'a pas d'opérateur ternaire direct, mais on peut faire :

```bash
#!/bin/bash

age=20
statut=$( [ $age -ge 18 ] && echo "majeur" || echo "mineur" )
echo "Vous êtes $statut"
```

## Script d'exemple complet

```bash
#!/bin/bash
# Script de vérification de prérequis

echo "=== Vérification des prérequis ==="

# Vérifier que le script est lancé en root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé en root"
   exit 1
fi

# Vérifier la présence de commandes
commandes=("git" "docker" "curl")

for cmd in "${commandes[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo "✓ $cmd est installé"
    else
        echo "✗ $cmd n'est pas installé"
        manquant=true
    fi
done

if [[ $manquant = true ]]; then
    echo ""
    echo "Installer les paquets manquants et relancer le script"
    exit 1
fi

# Vérifier l'espace disque
espace_libre=$(df / | tail -1 | awk '{print $4}')

if (( espace_libre < 1000000 )); then
    echo "⚠ Attention : Espace disque faible"
else
    echo "✓ Espace disque suffisant"
fi

echo ""
echo "Tous les prérequis sont satisfaits !"
exit 0
```

## Exercice pratique

Créez un script `verification_fichier.sh` :

```bash
#!/bin/bash
# Vérification de fichier

if [ $# -eq 0 ]; then
    echo "Usage: $0 <fichier>"
    exit 1
fi

fichier=$1

if [ ! -e "$fichier" ]; then
    echo "Le fichier n'existe pas"
    exit 1
fi

echo "=== Informations sur $fichier ==="

if [ -f "$fichier" ]; then
    echo "Type : Fichier régulier"
    echo "Taille : $(du -h "$fichier" | cut -f1)"
    echo "Lignes : $(wc -l < "$fichier")"
elif [ -d "$fichier" ]; then
    echo "Type : Répertoire"
    echo "Contenu : $(ls "$fichier" | wc -l) éléments"
fi

echo -n "Permissions : "
[ -r "$fichier" ] && echo -n "lecture "
[ -w "$fichier" ] && echo -n "écriture "
[ -x "$fichier" ] && echo -n "exécution"
echo ""
```

Testez-le :

```bash
chmod +x verification_fichier.sh
./verification_fichier.sh /etc/passwd
./verification_fichier.sh /etc
```

Créez le fichier de validation :

```bash
touch ~/conditions_ok
```

Excellent ! Passons maintenant aux boucles et fonctions.
