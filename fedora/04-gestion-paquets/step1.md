# Étape 1 : Comprendre les gestionnaires de paquets

## Qu'est-ce qu'un paquet ?

Un **paquet** est une archive contenant :
- Le programme exécutable
- Les fichiers de configuration
- La documentation
- Les métadonnées (version, dépendances, etc.)

Sous Ubuntu, les paquets ont l'extension `.deb` (Debian package).
Sous Fedora, les paquets ont l'extension `.rpm` (Red Hat Package Manager).

## Les dépôts (repositories)

Les **dépôts** sont des serveurs qui contiennent des milliers de paquets prêts à installer.

Ubuntu maintient plusieurs dépôts :
- **main** : paquets officiels supportés
- **universe** : paquets maintenus par la communauté
- **multiverse** : logiciels propriétaires
- **security** : mises à jour de sécurité

Fedora a aussi ses propres dépôts.

## Vérifier votre gestionnaire de paquets

Sur ce système Ubuntu, vous utilisez **apt**.

### Version d'apt

```bash
apt --version
```

Vous voyez la version installée.

### Quelle distribution ?

```bash
cat /etc/os-release
```

Vous voyez toutes les informations sur votre système.

## La commande sudo

La plupart des opérations de gestion de paquets nécessitent des **droits administrateur**.

Vous devez utiliser `sudo` (SuperUser DO) devant les commandes :

```bash
sudo apt update
```

💡 `sudo` vous demande votre mot de passe et vous donne temporairement les droits admin.

## Mettre à jour la liste des paquets

Avant d'installer quoi que ce soit, il faut **mettre à jour la liste** des paquets disponibles :

### Sur Ubuntu (apt)

```bash
sudo apt update
```

Cette commande :
- Contacte les dépôts configurés
- Télécharge la liste des paquets disponibles
- Met à jour la base de données locale

Vous voyez des lignes comme :
```
Hit:1 http://archive.ubuntu.com/ubuntu jammy InRelease
Get:2 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
```

### Équivalent Fedora (dnf)

Sur Fedora, vous feriez :
```bash
sudo dnf check-update
```

Ou simplement :
```bash
sudo dnf makecache
```

## Comprendre la sortie de apt update

Vous voyez plusieurs types de messages :

- **Hit** : Le dépôt n'a pas changé depuis la dernière mise à jour
- **Get** : apt télécharge de nouvelles informations
- **Ign** : Ignore ce dépôt (généralement normal)
- **Err** : Erreur (problème de connexion ou de configuration)

## Lister les paquets disponibles

### Voir tous les paquets disponibles

```bash
apt list
```

⚠️ Attention, il y en a des milliers ! Appuyez sur `Ctrl+C` pour arrêter.

### Voir combien de paquets

```bash
apt list | wc -l
```

Sur Ubuntu, il y a généralement plus de 60 000 paquets disponibles !

### Lister seulement les paquets installés

```bash
apt list --installed
```

Ou compter :
```bash
apt list --installed | wc -l
```

### Équivalent Fedora

```bash
# Tous les paquets
dnf list all

# Paquets installés
dnf list installed
```

## Informations sur un paquet

Pour obtenir des détails sur un paquet :

### Sur Ubuntu

```bash
apt show nginx
```

Vous voyez :
- Version
- Description
- Taille
- Dépendances
- Site web
- Etc.

Même si le paquet n'est pas installé !

### Équivalent Fedora

```bash
dnf info nginx
```

## Où sont installés les paquets ?

Les programmes installés via apt se trouvent généralement dans :
- `/usr/bin/` - Exécutables
- `/usr/lib/` - Bibliothèques
- `/etc/` - Configuration
- `/usr/share/doc/` - Documentation

Pour voir où un programme est installé :

```bash
which python3
```

Affiche : `/usr/bin/python3`

## Exercice pratique

### 1. Mettre à jour la liste

```bash
sudo apt update
```

### 2. Vérifier si un paquet est installé

```bash
apt list --installed | grep wget
```

Si `wget` apparaît, il est installé. Sinon, rien ne s'affiche.

### 3. Obtenir des infos sur différents paquets

```bash
apt show curl
apt show git
apt show tree
apt show htop
```

Lisez les descriptions pour comprendre à quoi sert chaque outil.

### 4. Chercher combien d'éditeurs de texte sont disponibles

```bash
apt search "text editor" | wc -l
```

Des dizaines d'options !

## Différences apt / apt-get

Vous verrez parfois `apt-get` au lieu de `apt` :

- **`apt`** : Nouvelle commande, plus moderne et lisible (recommandée)
- **`apt-get`** : Ancienne commande, toujours fonctionnelle (pour les scripts)

Pour un usage quotidien, utilisez `apt` qui est plus simple.

| Ancienne commande | Nouvelle commande |
|-------------------|-------------------|
| `apt-get update` | `apt update` |
| `apt-get install` | `apt install` |
| `apt-get remove` | `apt remove` |
| `apt-cache search` | `apt search` |
| `apt-cache show` | `apt show` |

## Résumé des commandes

```bash
# Ubuntu (apt)
sudo apt update                  # Mettre à jour la liste
apt list                         # Tous les paquets
apt list --installed             # Paquets installés
apt search nom                   # Rechercher
apt show nom                     # Infos sur un paquet
which commande                   # Où est installé

# Équivalent Fedora (dnf)
sudo dnf check-update            # Mettre à jour la liste
dnf list all                     # Tous les paquets
dnf list installed               # Paquets installés
dnf search nom                   # Rechercher
dnf info nom                     # Infos sur un paquet
which commande                   # Où est installé
```

---

✅ Explorez la liste des paquets, puis cliquez sur "Continuer" pour apprendre à rechercher !
