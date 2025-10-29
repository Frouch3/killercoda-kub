# Étape 1 : Créer et gérer des utilisateurs

## Introduction

Sous Linux, chaque personne utilisant le système dispose d'un **compte utilisateur** unique. La gestion des utilisateurs est essentielle pour la sécurité et l'organisation.

## Fichiers importants

Linux stocke les informations utilisateurs dans plusieurs fichiers :

- **/etc/passwd** : Liste des utilisateurs
- **/etc/shadow** : Mots de passe chiffrés (accessible uniquement par root)
- **/etc/group** : Informations sur les groupes

## Afficher les utilisateurs existants

Voyons qui existe déjà sur le système :

```bash
cat /etc/passwd
```

Chaque ligne suit ce format : `nom:x:UID:GID:description:répertoire_home:shell`

Pour voir uniquement votre utilisateur actuel :

```bash
whoami
id
```

## Créer un nouvel utilisateur

La commande **useradd** permet de créer des utilisateurs :

```bash
sudo useradd -m -s /bin/bash alice
```

Options importantes :
- `-m` : Crée le répertoire home (/home/alice)
- `-s /bin/bash` : Définit le shell par défaut

Définissez un mot de passe pour alice :

```bash
sudo passwd alice
```

Utilisez le mot de passe : `Password123`

## Vérifier la création

```bash
id alice
ls -la /home/alice
grep alice /etc/passwd
```

## Créer un utilisateur avec plus d'options

Créons un utilisateur "bob" avec des paramètres spécifiques :

```bash
sudo useradd -m -s /bin/bash -c "Bob Martin" -G sudo bob
sudo passwd bob
```

Utilisez également : `Password123`

Options :
- `-c "Bob Martin"` : Commentaire/nom complet
- `-G sudo` : Ajoute bob au groupe sudo

## Modifier un utilisateur existant

La commande **usermod** modifie les comptes :

```bash
# Changer le shell d'alice
sudo usermod -s /bin/sh alice

# Ajouter alice au groupe sudo
sudo usermod -aG sudo alice
```

**Important** : L'option `-aG` (append to group) ajoute SANS supprimer les groupes existants.

## Supprimer un utilisateur

La commande **userdel** supprime les comptes :

```bash
# Supprimer uniquement le compte (garde /home/alice)
sudo userdel alice

# Supprimer le compte ET son répertoire home
sudo userdel -r alice
```

Pour l'instant, ne supprimez pas alice !

## Exercice pratique

Créez un utilisateur nommé "charlie" avec :
- Un répertoire home
- Le shell /bin/bash
- Le mot de passe "Password123"

```bash
sudo useradd -m -s /bin/bash charlie
sudo passwd charlie
```

Vérifiez que charlie existe :

```bash
id charlie
```

Une fois charlie créé avec succès, la vérification automatique passera.
