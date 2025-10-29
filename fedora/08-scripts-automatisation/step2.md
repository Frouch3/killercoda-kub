# Étape 2 : Variables et entrées utilisateur

## Introduction

Les variables permettent de **stocker et réutiliser** des valeurs dans vos scripts.

## Déclarer et utiliser des variables

### Syntaxe de base

```bash
#!/bin/bash

# Déclaration (PAS D'ESPACES autour du =)
nom="Alice"
age=30
ville="Paris"

# Utilisation
echo "Nom : $nom"
echo "Age : $age"
echo "Ville : $ville"
```

**ATTENTION** : Pas d'espaces autour du `=` !

```bash
# CORRECT
variable="valeur"

# INCORRECT (erreur)
variable = "valeur"
```

### Guillemets

```bash
#!/bin/bash

# Guillemets simples : littéral
echo 'Hello $USER'  # Affiche : Hello $USER

# Guillemets doubles : interprétation
echo "Hello $USER"  # Affiche : Hello alice

# Sans guillemets : attention aux espaces
texte="Hello World"
echo $texte        # OK
echo "$texte"      # Meilleur (préserve espaces)
```

### Accolades pour clarifier

```bash
#!/bin/bash

nom="Alice"
echo "${nom}123"    # Alice123
echo "$nom123"      # Vide (cherche variable nom123)
```

## Variables spéciales

### Arguments du script

```bash
#!/bin/bash

echo "Nom du script : $0"
echo "Premier argument : $1"
echo "Deuxième argument : $2"
echo "Troisième argument : $3"
echo "Tous les arguments : $@"
echo "Nombre d'arguments : $#"
```

Tester :

```bash
./mon_script.sh arg1 arg2 arg3
```

### Autres variables spéciales

```bash
#!/bin/bash

echo "PID du script : $$"
echo "Code retour dernière commande : $?"
echo "PID dernière commande background : $!"
```

## Variables d'environnement

### Variables système

```bash
#!/bin/bash

echo "Utilisateur : $USER"
echo "Home : $HOME"
echo "Path : $PATH"
echo "Shell : $SHELL"
echo "Hostname : $HOSTNAME"
echo "PWD : $PWD"
```

### Créer une variable d'environnement

```bash
#!/bin/bash

# Variable locale (seulement dans ce script)
ma_variable="valeur"

# Variable d'environnement (accessible aux sous-processus)
export MA_VARIABLE="valeur exportée"
```

## Lecture de l'entrée utilisateur

### Commande read

```bash
#!/bin/bash

echo -n "Entrez votre nom : "
read nom
echo "Bonjour, $nom !"
```

### Read avec prompt intégré

```bash
#!/bin/bash

read -p "Votre nom : " nom
read -p "Votre âge : " age
echo "Vous êtes $nom et vous avez $age ans"
```

### Read avec valeur par défaut

```bash
#!/bin/bash

read -p "Environnement [dev] : " env
env=${env:-dev}  # dev si vide
echo "Environnement : $env"
```

### Read de mot de passe (masqué)

```bash
#!/bin/bash

read -sp "Mot de passe : " password
echo ""
echo "Mot de passe saisi (longueur : ${#password})"
```

### Read avec timeout

```bash
#!/bin/bash

if read -t 5 -p "Répondez dans 5 secondes : " reponse; then
    echo "Vous avez répondu : $reponse"
else
    echo "Timeout !"
fi
```

### Lire un fichier ligne par ligne

```bash
#!/bin/bash

while read ligne; do
    echo "Ligne : $ligne"
done < fichier.txt
```

## Opérations arithmétiques

### Syntaxe $((expression))

```bash
#!/bin/bash

a=10
b=5

echo "Addition : $((a + b))"
echo "Soustraction : $((a - b))"
echo "Multiplication : $((a * b))"
echo "Division : $((a / b))"
echo "Modulo : $((a % b))"
echo "Puissance : $((a ** 2))"
```

### Incrémenter/décrémenter

```bash
#!/bin/bash

compteur=0
echo "Compteur : $compteur"

((compteur++))
echo "Après ++ : $compteur"

((compteur += 5))
echo "Après += 5 : $compteur"

((compteur--))
echo "Après -- : $compteur"
```

### Commande let

```bash
#!/bin/bash

let "a = 5 + 3"
echo "a = $a"

let "b = a * 2"
echo "b = $b"
```

### Commande expr (obsolète)

```bash
#!/bin/bash

# Ancienne méthode (éviter)
resultat=$(expr 5 + 3)
echo "Résultat : $resultat"
```

## Longueur de chaîne

```bash
#!/bin/bash

texte="Bonjour"
echo "Longueur : ${#texte}"
```

## Substitution de chaîne

### Extraction

```bash
#!/bin/bash

texte="Bonjour le monde"

# Depuis position 8
echo "${texte:8}"        # le monde

# Depuis position 8, 2 caractères
echo "${texte:8:2}"      # le
```

### Remplacement

```bash
#!/bin/bash

texte="Hello World"

# Remplacer première occurrence
echo "${texte/World/Universe}"  # Hello Universe

# Remplacer toutes les occurrences
texte="foo bar foo"
echo "${texte//foo/baz}"  # baz bar baz
```

### Supprimer motif

```bash
#!/bin/bash

fichier="document.txt.backup"

# Supprimer extension
echo "${fichier%.backup}"     # document.txt

# Supprimer préfixe
echo "${fichier#document.}"   # txt.backup
```

## Tableaux (arrays)

### Déclaration

```bash
#!/bin/bash

# Méthode 1
fruits=("pomme" "banane" "orange")

# Méthode 2
fruits[0]="pomme"
fruits[1]="banane"
fruits[2]="orange"
```

### Accès aux éléments

```bash
#!/bin/bash

fruits=("pomme" "banane" "orange")

echo "Premier fruit : ${fruits[0]}"
echo "Deuxième fruit : ${fruits[1]}"
echo "Tous les fruits : ${fruits[@]}"
echo "Nombre d'éléments : ${#fruits[@]}"
```

### Parcourir un tableau

```bash
#!/bin/bash

fruits=("pomme" "banane" "orange")

for fruit in "${fruits[@]}"; do
    echo "Fruit : $fruit"
done
```

## Variables en lecture seule

```bash
#!/bin/bash

readonly PI=3.14159
echo "PI = $PI"

# Erreur si tentative de modification
# PI=3.14  # Génère une erreur
```

## Script d'exemple complet

```bash
#!/bin/bash
# Script de sauvegarde configuré par l'utilisateur

echo "=== Configuration de sauvegarde ==="

# Demander les paramètres
read -p "Répertoire source : " source
read -p "Répertoire destination : " destination
read -p "Nom de l'archive [backup] : " nom_archive
nom_archive=${nom_archive:-backup}

# Ajouter timestamp
timestamp=$(date +%Y%m%d_%H%M%S)
nom_complet="${nom_archive}_${timestamp}.tar.gz"

echo ""
echo "=== Paramètres ==="
echo "Source : $source"
echo "Destination : $destination"
echo "Archive : $nom_complet"
echo ""

read -p "Continuer ? (o/n) : " confirmer

if [ "$confirmer" = "o" ]; then
    echo "Création de l'archive..."
    tar -czf "${destination}/${nom_complet}" "$source"

    if [ $? -eq 0 ]; then
        echo "Sauvegarde réussie !"
        taille=$(du -h "${destination}/${nom_complet}" | cut -f1)
        echo "Taille : $taille"
    else
        echo "Erreur lors de la sauvegarde"
        exit 1
    fi
else
    echo "Sauvegarde annulée"
    exit 0
fi
```

## Exercice pratique

Créez un script `calculatrice.sh` :

```bash
#!/bin/bash
# Calculatrice simple

echo "=== Calculatrice Simple ==="

read -p "Premier nombre : " num1
read -p "Opération (+, -, *, /) : " op
read -p "Deuxième nombre : " num2

case $op in
    +)
        resultat=$((num1 + num2))
        ;;
    -)
        resultat=$((num1 - num2))
        ;;
    \*)
        resultat=$((num1 * num2))
        ;;
    /)
        if [ $num2 -eq 0 ]; then
            echo "Erreur : division par zéro"
            exit 1
        fi
        resultat=$((num1 / num2))
        ;;
    *)
        echo "Opération invalide"
        exit 1
        ;;
esac

echo "Résultat : $num1 $op $num2 = $resultat"
```

Testez-le :

```bash
chmod +x calculatrice.sh
./calculatrice.sh
```

Créez le fichier de validation :

```bash
touch ~/variables_ok
```

Parfait ! Passons aux conditions dans la prochaine étape.
