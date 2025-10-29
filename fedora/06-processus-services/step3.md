# Étape 3 : Comprendre systemd et les services

## Introduction

**systemd** est le système d'initialisation (init) moderne de Linux. Il gère le démarrage du système et les services (daemons).

## Qu'est-ce qu'un service ?

Un **service** (ou daemon) est un processus qui :
- Tourne en arrière-plan
- Démarre automatiquement au boot
- N'a pas d'interface utilisateur
- Fournit une fonctionnalité système

Exemples de services :
- **ssh** : Serveur SSH pour connexions distantes
- **cron** : Planificateur de tâches
- **nginx/apache** : Serveurs web
- **mysql/postgresql** : Bases de données
- **systemd-networkd** : Gestion réseau

## systemd : le gestionnaire de services

### Vérifier que systemd est utilisé

```bash
ps -p 1
```

Le processus 1 (init) devrait être **systemd**.

### Informations système

```bash
# Version de systemd
systemctl --version

# État général du système
systemctl status

# Temps de démarrage
systemd-analyze

# Détails du boot
systemd-analyze blame
```

## Les unités systemd

systemd gère des **unités** (units) de différents types :

| Type | Extension | Usage |
|------|-----------|-------|
| Service | .service | Services/daemons |
| Socket | .socket | Sockets d'écoute |
| Device | .device | Périphériques |
| Mount | .mount | Points de montage |
| Timer | .timer | Tâches planifiées |
| Target | .target | Groupes d'unités |

Nous nous concentrons sur les **.service**.

## Lister les services

### Tous les services

```bash
systemctl list-units --type=service
```

### Services actifs uniquement

```bash
systemctl list-units --type=service --state=running
```

### Tous les services (même inactifs)

```bash
systemctl list-unit-files --type=service
```

### Rechercher un service

```bash
systemctl list-units --type=service | grep ssh
```

## État d'un service

### Voir le statut

```bash
# Service SSH
systemctl status ssh

# ou sur certaines distributions
systemctl status sshd
```

Informations affichées :
- **Loaded** : Chargé et activé ou non
- **Active** : État actuel (running, dead, failed)
- **Process** : PID principal
- **Main PID** : Processus principal
- **Tasks** : Nombre de tâches
- **Memory** : Utilisation mémoire
- **Logs** : Dernières lignes de logs

### État simplifié

```bash
# Juste l'état actif/inactif
systemctl is-active ssh

# Activé au démarrage ?
systemctl is-enabled ssh

# Échec ?
systemctl is-failed ssh
```

## Services activés au démarrage

Un service peut être :
- **enabled** : Démarre automatiquement au boot
- **disabled** : Ne démarre pas automatiquement
- **static** : Ne peut pas être activé (dépendance)
- **masked** : Complètement désactivé

```bash
# Voir les services enabled
systemctl list-unit-files --type=service --state=enabled

# Voir les services disabled
systemctl list-unit-files --type=service --state=disabled
```

## Fichiers de configuration des services

Les fichiers .service sont dans :
- **/lib/systemd/system/** : Services système
- **/etc/systemd/system/** : Personnalisations admin
- **/run/systemd/system/** : Services temporaires

### Voir un fichier service

```bash
# Service SSH
cat /lib/systemd/system/ssh.service
```

Structure typique :

```ini
[Unit]
Description=OpenBSD Secure Shell server
After=network.target auditd.service
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Service]
Type=notify
ExecStartPre=/usr/sbin/sshd -t
ExecStart=/usr/sbin/sshd -D
ExecReload=/usr/sbin/sshd -t
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Sections :
- **[Unit]** : Description et dépendances
- **[Service]** : Comment lancer/arrêter
- **[Install]** : Comment l'activer

## Targets : niveaux d'exécution

Les **targets** remplacent les anciens runlevels :

| Target | Ancien runlevel | Description |
|--------|-----------------|-------------|
| poweroff.target | 0 | Arrêt système |
| rescue.target | 1 | Mode secours |
| multi-user.target | 3 | Multi-utilisateur CLI |
| graphical.target | 5 | Mode graphique |
| reboot.target | 6 | Redémarrage |

### Voir le target actuel

```bash
systemctl get-default
```

### Changer le target par défaut

```bash
# Passer en mode graphique
sudo systemctl set-default graphical.target

# Passer en mode texte
sudo systemctl set-default multi-user.target
```

### Changer de target immédiatement

```bash
# Aller en rescue mode
sudo systemctl isolate rescue.target

# Revenir en multi-user
sudo systemctl isolate multi-user.target
```

## Dépendances entre services

### Voir les dépendances

```bash
# Services requis par ssh
systemctl list-dependencies ssh

# Avec plus de détails
systemctl list-dependencies ssh --all
```

### Types de dépendances

- **Requires** : Dépendance stricte
- **Wants** : Dépendance souple
- **After** : Démarre après
- **Before** : Démarre avant

## Services échoués

### Lister les échecs

```bash
systemctl --failed
```

### Réinitialiser les échecs

```bash
sudo systemctl reset-failed
```

## Exercice pratique

1. Listez tous les services en cours :

```bash
systemctl list-units --type=service --state=running
```

2. Vérifiez le statut du service SSH :

```bash
systemctl status ssh
```

3. Voyez si SSH est activé au démarrage :

```bash
systemctl is-enabled ssh
```

4. Créez un fichier de validation :

```bash
touch ~/systemd_compris
```

Une fois le fichier créé, vous pouvez passer à l'étape suivante où nous manipulerons concrètement les services !
