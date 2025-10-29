# Étape 1 : Lister et surveiller les processus

## Introduction

Chaque programme qui s'exécute sur Linux est un **processus**. Savoir les lister et les surveiller est essentiel pour comprendre ce qui se passe sur le système.

## Afficher les processus avec ps

La commande **ps** (process status) affiche les processus.

### Processus de la session actuelle

```bash
ps
```

Affiche uniquement VOS processus dans le terminal actuel.

### Tous les processus

```bash
ps aux
```

Options :
- `a` : tous les processus de tous les utilisateurs
- `u` : format détaillé (utilisateur, CPU, mémoire)
- `x` : inclut les processus sans terminal

### Comprendre la sortie

```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 168872 11532 ?        Ss   10:00   0:01 /sbin/init
```

Colonnes importantes :
- **USER** : Utilisateur propriétaire
- **PID** : Process ID (identifiant unique)
- **%CPU** : Utilisation CPU
- **%MEM** : Utilisation mémoire
- **STAT** : État du processus
- **COMMAND** : Commande exécutée

### États des processus (STAT)

| Code | Signification |
|------|---------------|
| R | Running (en cours) |
| S | Sleeping (en attente) |
| D | Uninterruptible sleep (I/O) |
| Z | Zombie (terminé mais non nettoyé) |
| T | Stopped (arrêté) |
| I | Idle (inactif) |

Modificateurs :
- `s` : session leader
- `+` : foreground (premier plan)
- `<` : haute priorité
- `N` : basse priorité

## Rechercher un processus

### Avec ps et grep

```bash
# Chercher les processus SSH
ps aux | grep sshd

# Chercher les processus d'un utilisateur
ps aux | grep root | head -10
```

### Avec pgrep

Plus efficace que `ps | grep` :

```bash
# PID des processus ssh
pgrep ssh

# Avec le nom complet
pgrep -a ssh

# Processus d'un utilisateur spécifique
pgrep -u root
```

## Surveiller en temps réel avec top

La commande **top** affiche les processus en temps réel :

```bash
top
```

Commandes interactives dans top :
- **q** : quitter
- **h** : aide
- **k** : kill un processus (entrer le PID)
- **u** : filtrer par utilisateur
- **M** : trier par mémoire
- **P** : trier par CPU
- **1** : afficher tous les CPU

### Informations affichées

En haut :
- Uptime du système
- Nombre d'utilisateurs connectés
- Load average (charge système)
- Tâches (running, sleeping, stopped, zombie)
- Utilisation CPU et mémoire

En bas :
- Liste des processus triée par utilisation CPU

## Alternative moderne : htop

**htop** est plus convivial que top :

```bash
# Installer htop si nécessaire
sudo apt update
sudo apt install -y htop

# Lancer htop
htop
```

Avantages de htop :
- Interface colorée et intuitive
- Utilisation de la souris
- Barre de progression visuelle
- Arborescence des processus (F5)
- Filtrage facile (F4)

Touches utiles :
- **F1** : Aide
- **F3** : Rechercher
- **F4** : Filtrer
- **F5** : Arborescence
- **F6** : Trier
- **F9** : Kill
- **F10** : Quitter

## Afficher l'arborescence des processus

La commande **pstree** montre la hiérarchie :

```bash
pstree
```

Chaque processus a un parent (PPID - Parent Process ID). Le processus racine est **systemd** (PID 1).

Avec détails :

```bash
pstree -p    # Affiche les PID
pstree -u    # Affiche les utilisateurs
```

## Informations détaillées d'un processus

Le répertoire **/proc/[PID]** contient toutes les infos :

```bash
# Voir les détails du processus 1 (systemd)
ls /proc/1/

# Ligne de commande complète
cat /proc/1/cmdline | tr '\0' ' '
echo

# Variables d'environnement
cat /proc/1/environ | tr '\0' '\n' | head -10

# Statut détaillé
cat /proc/1/status | head -20
```

## Monitorer les ressources système

### Utilisation CPU

```bash
# Charge CPU moyenne
uptime

# Détails par CPU
mpstat 1 5   # Si sysstat installé
```

### Utilisation mémoire

```bash
# Vue d'ensemble
free -h

# Détails
cat /proc/meminfo | head -20
```

### Disque I/O

```bash
# Statistiques I/O
iostat   # Si sysstat installé

# Processus utilisant le disque
iotop    # Si installé, nécessite root
```

## Exercice pratique

1. Listez tous les processus :

```bash
ps aux | less
```

2. Trouvez le PID du processus systemd :

```bash
pgrep -a systemd | head -1
```

3. Lancez top et observez pendant quelques secondes :

```bash
top
```

Appuyez sur **q** pour quitter.

4. Créez un fichier pour valider l'étape :

```bash
touch ~/processus_explores
```

Une fois le fichier créé, la vérification passera et vous pourrez continuer.
