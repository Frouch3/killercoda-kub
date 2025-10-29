# Étape 1 : Bases du scripting bash

## Introduction

Un script bash est un fichier texte contenant des commandes shell. Apprenons à créer notre premier script !

## Créer un script simple

### 1. Créer le fichier

```bash
cd ~
nano premier_script.sh
```

### 2. Contenu du script

```bash
#!/bin/bash
# Mon premier script bash

echo "Bonjour, monde!"
echo "Nous sommes le $(date)"
echo "Utilisateur actuel : $(whoami)"
```

Sauvegardez (Ctrl+O, Enter, Ctrl+X).

### 3. Rendre exécutable

```bash
chmod +x premier_script.sh
```

### 4. Exécuter

```bash
./premier_script.sh
```

## Le shebang (#!)

La première ligne `#!/bin/bash` est le **shebang** :

- Indique quel interpréteur utiliser
- Obligatoire pour les scripts exécutables
- Doit être la toute première ligne

Autres shebangs courants :

```bash
#!/bin/sh          # Shell POSIX (plus portable)
#!/usr/bin/env bash  # Trouve bash dans le PATH (recommandé)
#!/usr/bin/python3   # Script Python
#!/usr/bin/env node  # Script Node.js
```

## Commentaires

Les commentaires commencent par `#` :

```bash
#!/bin/bash

# Ceci est un commentaire
echo "Cette ligne s'exécute"  # Commentaire en fin de ligne

# Les commentaires multi-lignes :
# Ligne 1
# Ligne 2
# Ligne 3
```

## Afficher du texte avec echo

```bash
#!/bin/bash

# Simple
echo "Hello World"

# Sans retour à la ligne
echo -n "Pas de saut "
echo "de ligne"

# Avec échappements
echo -e "Ligne 1\nLigne 2\nLigne 3"

# Couleurs (codes ANSI)
echo -e "\e[31mRouge\e[0m"
echo -e "\e[32mVert\e[0m"
echo -e "\e[33mJaune\e[0m"
echo -e "\e[34mBleu\e[0m"
```

## Exécuter des commandes

Deux méthodes pour capturer la sortie d'une commande :

### Avec $()

```bash
#!/bin/bash

date_actuelle=$(date)
echo "Date : $date_actuelle"

nombre_fichiers=$(ls | wc -l)
echo "Fichiers dans le répertoire : $nombre_fichiers"
```

### Avec backticks (obsolète)

```bash
#!/bin/bash

# Ancienne syntaxe (à éviter)
date_actuelle=`date`
echo "Date : $date_actuelle"
```

**Recommandation** : Utilisez toujours `$()` (plus lisible et nestable).

## Code de retour (exit status)

Chaque commande retourne un code :
- **0** : Succès
- **Non-zero** : Erreur

### Vérifier le code de retour

```bash
#!/bin/bash

ls /etc/passwd
echo "Code de retour : $?"

ls /fichier_inexistant
echo "Code de retour : $?"
```

La variable `$?` contient le code de retour de la dernière commande.

### Définir le code de retour

```bash
#!/bin/bash

echo "Script terminé avec succès"
exit 0  # Succès

# ou

echo "Erreur détectée"
exit 1  # Échec
```

## Modes d'exécution

### Méthode 1 : Directement (nécessite chmod +x)

```bash
./mon_script.sh
```

### Méthode 2 : Avec bash

```bash
bash mon_script.sh
```

Pas besoin de chmod +x, mais ignore le shebang.

### Méthode 3 : Avec source (dans le shell actuel)

```bash
source mon_script.sh
# ou
. mon_script.sh
```

Les modifications (cd, variables) affectent le shell actuel.

## Redirections

### Sortie standard (stdout)

```bash
#!/bin/bash

# Rediriger vers un fichier (écrase)
echo "Texte" > fichier.txt

# Ajouter à un fichier
echo "Autre texte" >> fichier.txt
```

### Erreur standard (stderr)

```bash
#!/bin/bash

# Rediriger les erreurs
ls /inexistant 2> erreurs.log

# Rediriger stdout ET stderr
commande > sortie.log 2>&1

# Ou en syntaxe moderne
commande &> sortie.log
```

### Ignorer la sortie

```bash
#!/bin/bash

# Tout dans le trou noir
commande > /dev/null 2>&1
```

## Pipelines

Chaîner des commandes avec `|` :

```bash
#!/bin/bash

# Compter les fichiers .txt
ls | grep "\.txt$" | wc -l

# Top 5 des fichiers les plus gros
du -h | sort -hr | head -5

# Processus utilisant le plus de CPU
ps aux | sort -nrk 3 | head -5
```

## Opérateurs logiques

### ET logique (&&)

```bash
#!/bin/bash

# Exécute cmd2 SI cmd1 réussit
mkdir /tmp/test && cd /tmp/test && touch fichier.txt
```

### OU logique (||)

```bash
#!/bin/bash

# Exécute cmd2 SI cmd1 échoue
ls fichier.txt || echo "Fichier introuvable"
```

### Combinaisons

```bash
#!/bin/bash

# Créer répertoire ET entrer dedans, sinon erreur
mkdir /tmp/monrep && cd /tmp/monrep || exit 1
```

## Script d'exemple complet

```bash
#!/bin/bash
# Script d'information système
# Auteur : Votre Nom
# Date : $(date +%Y-%m-%d)

echo "======================================"
echo "     INFORMATIONS SYSTÈME"
echo "======================================"
echo ""

echo "Nom d'hôte : $(hostname)"
echo "Utilisateur : $(whoami)"
echo "Date : $(date)"
echo "Uptime : $(uptime -p)"
echo ""

echo "======================================"
echo "     UTILISATION DISQUE"
echo "======================================"
df -h / | tail -1
echo ""

echo "======================================"
echo "     UTILISATION MÉMOIRE"
echo "======================================"
free -h | grep "Mem:"
echo ""

echo "======================================"
echo "     PROCESSUS ACTIFS"
echo "======================================"
ps aux | wc -l
echo ""

exit 0
```

## Déboguer un script

### Mode verbeux

```bash
bash -x mon_script.sh
```

Affiche chaque commande avant exécution.

### Dans le script

```bash
#!/bin/bash
set -x  # Active le mode debug

commandes...

set +x  # Désactive le mode debug
```

### Arrêt sur erreur

```bash
#!/bin/bash
set -e  # Arrête le script si une commande échoue

commande1
commande2  # Si échoue, le script s'arrête
commande3
```

### Options combinées

```bash
#!/bin/bash
set -euxo pipefail

# -e : exit on error
# -u : exit si variable non définie
# -x : mode debug
# -o pipefail : échec si une commande du pipeline échoue
```

## Exercice pratique

Créez un script `info_systeme.sh` :

```bash
#!/bin/bash
# Script d'information système

echo "=== Informations Système ==="
echo "Date : $(date)"
echo "Hostname : $(hostname)"
echo "User : $(whoami)"
echo "Shell : $SHELL"
echo ""
echo "=== Réseau ==="
ip -4 addr show | grep inet
echo ""
echo "=== Espace disque ==="
df -h / | tail -1
```

Rendez-le exécutable et testez :

```bash
chmod +x info_systeme.sh
./info_systeme.sh
```

Créez aussi le fichier de validation :

```bash
touch ~/scripts_bases_ok
```

Excellent ! Passons aux variables.
