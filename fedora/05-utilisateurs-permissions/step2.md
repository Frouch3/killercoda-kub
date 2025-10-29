# Étape 2 : Comprendre les permissions de fichiers

## Introduction

Linux utilise un **système de permissions** pour contrôler qui peut lire, écrire ou exécuter chaque fichier et répertoire.

## Afficher les permissions

La commande `ls -l` affiche les permissions :

```bash
ls -l /etc/passwd
```

Vous verrez quelque chose comme :
```
-rw-r--r-- 1 root root 2834 Oct 29 10:00 /etc/passwd
```

## Décoder les permissions

Découpons `-rw-r--r--` :

```
-  rw-  r--  r--
│   │    │    │
│   │    │    └─ Autres (others) : r-- (lecture seule)
│   │    └────── Groupe (group)  : r-- (lecture seule)
│   └─────────── Propriétaire (user) : rw- (lecture + écriture)
└─────────────── Type de fichier : - (fichier normal)
```

## Types de fichiers

Le premier caractère indique le type :
- `-` : fichier normal
- `d` : répertoire (directory)
- `l` : lien symbolique
- `c` : périphérique caractère
- `b` : périphérique bloc

## Les trois permissions de base

Chaque groupe (user/group/others) peut avoir :

| Permission | Fichier | Répertoire |
|------------|---------|------------|
| **r** (read) | Lire le contenu | Lister les fichiers |
| **w** (write) | Modifier le contenu | Créer/supprimer des fichiers |
| **x** (execute) | Exécuter le fichier | Accéder au répertoire |

## Exemples pratiques

Créons des fichiers de test :

```bash
cd ~
touch fichier_test.txt
echo "Contenu secret" > fichier_test.txt
ls -l fichier_test.txt
```

Créons un script :

```bash
echo '#!/bin/bash' > script_test.sh
echo 'echo "Bonjour!"' >> script_test.sh
ls -l script_test.sh
```

Essayez de l'exécuter :

```bash
./script_test.sh
```

**Erreur** : Permission denied ! Le fichier n'a pas la permission d'exécution.

## Représentation numérique (octale)

Les permissions peuvent aussi s'exprimer en chiffres :

| Permission | Binaire | Octal |
|------------|---------|-------|
| --- | 000 | 0 |
| --x | 001 | 1 |
| -w- | 010 | 2 |
| -wx | 011 | 3 |
| r-- | 100 | 4 |
| r-x | 101 | 5 |
| rw- | 110 | 6 |
| rwx | 111 | 7 |

Exemple : `rwxr-xr--` = `754`
- Propriétaire : rwx = 7
- Groupe : r-x = 5
- Autres : r-- = 4

## Permissions par défaut

Les nouveaux fichiers ont généralement `644` (-rw-r--r--) :
- Propriétaire : lecture + écriture
- Groupe : lecture seule
- Autres : lecture seule

Les répertoires ont généralement `755` (drwxr-xr-x) :
- Propriétaire : lecture + écriture + exécution
- Groupe : lecture + exécution
- Autres : lecture + exécution

## Exercice pratique

Créez un répertoire de test et explorez ses permissions :

```bash
mkdir test_permissions
ls -ld test_permissions
```

Créez plusieurs fichiers dedans :

```bash
touch test_permissions/fichier1.txt
touch test_permissions/fichier2.txt
echo "Test" > test_permissions/fichier3.txt
ls -l test_permissions/
```

Observez attentivement les permissions de chaque élément. Dans l'étape suivante, nous apprendrons à les modifier !
