# Gestion des paquets sous Linux

## Objectifs de cet exercice

Dans ce scénario, vous allez apprendre à :

- **Comprendre** les gestionnaires de paquets Linux
- **Rechercher** des logiciels disponibles
- **Installer** des applications en ligne de commande
- **Mettre à jour** votre système
- **Désinstaller** et **nettoyer** les paquets inutiles
- **Comparer** apt (Debian/Ubuntu) et dnf (Fedora/RHEL)

## Qu'est-ce qu'un gestionnaire de paquets ?

Un **gestionnaire de paquets** est un outil qui vous permet d'installer, mettre à jour et supprimer des logiciels facilement, directement depuis les dépôts officiels.

C'est l'équivalent de :
- **Windows** : Microsoft Store (mais en bien plus puissant !)
- **macOS** : App Store + Homebrew
- **Android/iOS** : Google Play / App Store

Mais sous Linux, **tout** se gère en ligne de commande !

## Les principaux gestionnaires de paquets

Linux utilise différents gestionnaires selon la distribution :

### 🔷 **apt** (Debian, Ubuntu, Linux Mint)
- Utilisé sur Ubuntu et dérivés
- Format de paquet : `.deb`
- Commande : `apt` ou `apt-get`
- **C'est celui que nous allons utiliser dans ce scénario**

### 🔶 **dnf** (Fedora, RHEL, CentOS)
- Utilisé sur Fedora, Red Hat, CentOS
- Format de paquet : `.rpm`
- Commande : `dnf` (remplace `yum`)
- Nous expliquerons les équivalences avec apt

### Autres gestionnaires
- **pacman** (Arch Linux)
- **zypper** (openSUSE)
- **snap** et **flatpak** (universels)

## apt vs dnf : Les équivalences

Dans ce scénario, nous utilisons **Ubuntu (apt)**, mais voici les équivalences avec **Fedora (dnf)** :

| Action | Ubuntu (apt) | Fedora (dnf) |
|--------|--------------|--------------|
| Mettre à jour la liste | `apt update` | `dnf check-update` |
| Installer un paquet | `apt install nom` | `dnf install nom` |
| Supprimer un paquet | `apt remove nom` | `dnf remove nom` |
| Chercher un paquet | `apt search nom` | `dnf search nom` |
| Mettre à jour tout | `apt upgrade` | `dnf upgrade` |
| Infos sur un paquet | `apt show nom` | `dnf info nom` |
| Lister les installés | `apt list --installed` | `dnf list installed` |
| Nettoyer | `apt autoremove` | `dnf autoremove` |

💡 **Bonne nouvelle** : Les commandes sont très similaires !

## Pourquoi utiliser un gestionnaire de paquets ?

✅ **Avantages** :
- Installation en une seule commande
- Mises à jour automatiques de tous vos logiciels
- Gestion des dépendances automatique
- Sécurité : paquets vérifiés et signés
- Désinstallation propre
- Gratuit et open source

❌ **Sans gestionnaire** :
- Télécharger manuellement depuis des sites web
- Risques de sécurité (faux sites, malware)
- Pas de mises à jour automatiques
- Gestion manuelle des dépendances

## Prérequis

- Connexion Internet
- Droits administrateur (sudo)
- Connaissances de base en ligne de commande

---

🚀 **Prêt à devenir un expert en gestion de paquets ?** Cliquez sur "Commencer" !
