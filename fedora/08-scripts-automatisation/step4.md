# Étape 4 : Boucles et fonctions

## Introduction

Les **boucles** permettent de répéter des actions, et les **fonctions** de réutiliser du code.

## Boucle for

### Syntaxe de base

```bash
#!/bin/bash

for i in 1 2 3 4 5; do
    echo "Nombre : $i"
done
```

### Avec séquence

```bash
#!/bin/bash

# De 1 à 10
for i in {1..10}; do
    echo "Itération $i"
done

# De 0 à 100 par pas de 10
for i in {0..100..10}; do
    echo "$i"
done
```

### Style C

```bash
#!/bin/bash

for ((i=1; i<=10; i++)); do
    echo "Compteur : $i"
done
```

### Parcourir des fichiers

```bash
#!/bin/bash

for fichier in *.txt; do
    echo "Traitement de $fichier"
    wc -l "$fichier"
done
```

### Parcourir un tableau

```bash
#!/bin/bash

fruits=("pomme" "banane" "orange" "kiwi")

for fruit in "${fruits[@]}"; do
    echo "Fruit : $fruit"
done
```

### Parcourir une liste de commandes

```bash
#!/bin/bash

for user in $(cat /etc/passwd | cut -d: -f1); do
    echo "Utilisateur : $user"
done
```

## Boucle while

### Syntaxe

```bash
#!/bin/bash

compteur=1

while [ $compteur -le 5 ]; do
    echo "Compteur : $compteur"
    ((compteur++))
done
```

### Lire un fichier ligne par ligne

```bash
#!/bin/bash

while read ligne; do
    echo "Ligne : $ligne"
done < fichier.txt
```

### Boucle infinie

```bash
#!/bin/bash

while true; do
    echo "En cours... (Ctrl+C pour arrêter)"
    sleep 1
done
```

### Attendre qu'un service démarre

```bash
#!/bin/bash

echo "Attente du service..."

while ! systemctl is-active --quiet nginx; do
    echo "Service pas encore démarré..."
    sleep 2
done

echo "Service démarré !"
```

## Boucle until

Inverse de while (boucle TANT QUE condition fausse) :

```bash
#!/bin/bash

compteur=1

until [ $compteur -gt 5 ]; do
    echo "Compteur : $compteur"
    ((compteur++))
done
```

## Contrôle des boucles

### break : Sortir de la boucle

```bash
#!/bin/bash

for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "Arrêt à 5"
        break
    fi
    echo "Nombre : $i"
done
```

### continue : Passer à l'itération suivante

```bash
#!/bin/bash

for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        continue  # Sauter les pairs
    fi
    echo "Nombre impair : $i"
done
```

## Fonctions

### Déclaration et appel

```bash
#!/bin/bash

# Déclaration
dire_bonjour() {
    echo "Bonjour !"
}

# Appel
dire_bonjour
```

### Avec paramètres

```bash
#!/bin/bash

dire_bonjour() {
    local nom=$1
    echo "Bonjour, $nom !"
}

dire_bonjour "Alice"
dire_bonjour "Bob"
```

### Plusieurs paramètres

```bash
#!/bin/bash

addition() {
    local a=$1
    local b=$2
    local resultat=$((a + b))
    echo $resultat
}

resultat=$(addition 5 3)
echo "5 + 3 = $resultat"
```

### Variables locales

```bash
#!/bin/bash

ma_fonction() {
    local variable_locale="Je suis locale"
    variable_globale="Je suis globale"
    echo "Dans fonction : $variable_locale"
}

ma_fonction
# echo "$variable_locale"  # Erreur : n'existe pas ici
echo "$variable_globale"   # OK
```

### Return (code de retour)

```bash
#!/bin/bash

est_pair() {
    local nombre=$1
    if [ $((nombre % 2)) -eq 0 ]; then
        return 0  # Vrai
    else
        return 1  # Faux
    fi
}

if est_pair 4; then
    echo "4 est pair"
fi

if ! est_pair 5; then
    echo "5 n'est pas pair"
fi
```

**Note** : `return` retourne un code (0-255), pas une valeur. Pour retourner une valeur, utilisez `echo`.

## Exemples pratiques

### Fonction de backup

```bash
#!/bin/bash

backup() {
    local source=$1
    local destination=$2
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local archive="${destination}/backup_${timestamp}.tar.gz"

    echo "Création backup de $source..."

    if tar -czf "$archive" "$source" 2>/dev/null; then
        echo "✓ Backup créé : $archive"
        return 0
    else
        echo "✗ Erreur lors du backup"
        return 1
    fi
}

# Utilisation
backup "/etc/nginx" "/tmp"
```

### Fonction de validation

```bash
#!/bin/bash

valider_email() {
    local email=$1
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Test
if valider_email "user@example.com"; then
    echo "Email valide"
else
    echo "Email invalide"
fi
```

### Menu avec fonctions

```bash
#!/bin/bash

afficher_date() {
    echo "Date actuelle : $(date)"
}

afficher_utilisateurs() {
    echo "Utilisateurs connectés :"
    who
}

afficher_disque() {
    echo "Espace disque :"
    df -h /
}

menu() {
    echo ""
    echo "=== Menu Principal ==="
    echo "1. Afficher la date"
    echo "2. Afficher les utilisateurs"
    echo "3. Afficher l'espace disque"
    echo "4. Quitter"
    echo ""
}

while true; do
    menu
    read -p "Votre choix : " choix

    case $choix in
        1)
            afficher_date
            ;;
        2)
            afficher_utilisateurs
            ;;
        3)
            afficher_disque
            ;;
        4)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Choix invalide"
            ;;
    esac

    read -p "Appuyez sur Entrée pour continuer..."
done
```

## Script complet d'exemple

```bash
#!/bin/bash
# Gestionnaire de serveurs

# Fonction pour vérifier si un serveur répond
verifier_serveur() {
    local serveur=$1
    if ping -c 1 -W 1 "$serveur" &> /dev/null; then
        echo "✓ $serveur est accessible"
        return 0
    else
        echo "✗ $serveur est inaccessible"
        return 1
    fi
}

# Fonction pour vérifier un port
verifier_port() {
    local serveur=$1
    local port=$2

    if timeout 2 bash -c "cat < /dev/null > /dev/tcp/$serveur/$port" 2>/dev/null; then
        echo "✓ Port $port ouvert sur $serveur"
        return 0
    else
        echo "✗ Port $port fermé sur $serveur"
        return 1
    fi
}

# Fonction principale
verifier_infrastructure() {
    local -a serveurs=("$@")

    echo "=== Vérification de l'infrastructure ==="
    echo ""

    for serveur in "${serveurs[@]}"; do
        echo "Vérification de $serveur..."

        if verifier_serveur "$serveur"; then
            # Vérifier ports courants
            verifier_port "$serveur" 80
            verifier_port "$serveur" 443
            verifier_port "$serveur" 22
        fi

        echo ""
    done
}

# Liste de serveurs à vérifier
serveurs=(
    "google.com"
    "github.com"
    "localhost"
)

verifier_infrastructure "${serveurs[@]}"
```

## Bibliothèque de fonctions

Créez un fichier `lib.sh` avec des fonctions réutilisables :

```bash
# lib.sh
# Bibliothèque de fonctions utiles

log_info() {
    echo "[INFO] $(date +%Y-%m-%d\ %H:%M:%S) - $1"
}

log_error() {
    echo "[ERROR] $(date +%Y-%m-%d\ %H:%M:%S) - $1" >&2
}

log_success() {
    echo "[SUCCESS] $(date +%Y-%m-%d\ %H:%M:%S) - $1"
}

verifier_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Ce script doit être lancé en root"
        exit 1
    fi
}

fichier_existe() {
    local fichier=$1
    if [ -f "$fichier" ]; then
        return 0
    else
        return 1
    fi
}
```

Utilisation dans un autre script :

```bash
#!/bin/bash

# Charger la bibliothèque
source ./lib.sh

log_info "Démarrage du script"

if fichier_existe "/etc/passwd"; then
    log_success "Fichier passwd trouvé"
else
    log_error "Fichier passwd introuvable"
fi
```

## Exercice pratique

Créez un script `traitement_fichiers.sh` :

```bash
#!/bin/bash
# Traitement de fichiers en masse

traiter_fichier() {
    local fichier=$1

    if [ ! -f "$fichier" ]; then
        echo "✗ $fichier n'existe pas"
        return 1
    fi

    echo "Traitement de $fichier..."

    # Compter lignes
    local lignes=$(wc -l < "$fichier")
    echo "  - Lignes : $lignes"

    # Compter mots
    local mots=$(wc -w < "$fichier")
    echo "  - Mots : $mots"

    # Taille
    local taille=$(du -h "$fichier" | cut -f1)
    echo "  - Taille : $taille"

    return 0
}

# Traiter tous les fichiers .txt
echo "=== Traitement des fichiers texte ==="

compteur=0
for fichier in *.txt; do
    if [ -f "$fichier" ]; then
        traiter_fichier "$fichier"
        ((compteur++))
        echo ""
    fi
done

echo "Total : $compteur fichiers traités"
```

Testez-le :

```bash
chmod +x traitement_fichiers.sh
touch test1.txt test2.txt test3.txt
echo "Contenu de test" > test1.txt
./traitement_fichiers.sh
```

Créez le fichier de validation :

```bash
touch ~/boucles_fonctions_ok
```

Excellent ! Passons maintenant à l'automatisation avec cron.
