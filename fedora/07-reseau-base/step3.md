# Étape 3 : Gérer le pare-feu

## Introduction

Un **pare-feu** (firewall) contrôle le trafic réseau entrant et sortant. C'est essentiel pour la **sécurité** de votre système.

## UFW : Uncomplicated Firewall

**UFW** (Uncomplicated Firewall) est un frontend simple pour iptables.

### Installation

```bash
sudo apt update
sudo apt install -y ufw
```

### État du pare-feu

```bash
sudo ufw status
```

Si désactivé :
```
Status: inactive
```

### Activer UFW

```bash
sudo ufw enable
```

**ATTENTION** : Sur un serveur distant (SSH), ajoutez d'abord une règle SSH pour ne pas vous enfermer dehors !

```bash
sudo ufw allow ssh
sudo ufw enable
```

### Désactiver UFW

```bash
sudo ufw disable
```

## Règles de base

### Autoriser un port

```bash
# Port 80 (HTTP)
sudo ufw allow 80

# Port 443 (HTTPS)
sudo ufw allow 443

# Port spécifique
sudo ufw allow 3000
```

### Autoriser un service

UFW connaît les services courants :

```bash
sudo ufw allow ssh        # Port 22
sudo ufw allow http       # Port 80
sudo ufw allow https      # Port 443
sudo ufw allow mysql      # Port 3306
```

### Autoriser un protocole spécifique

```bash
# TCP seulement
sudo ufw allow 80/tcp

# UDP seulement
sudo ufw allow 53/udp
```

### Autoriser une plage de ports

```bash
sudo ufw allow 8000:8010/tcp
```

## Bloquer un port

```bash
# Bloquer le port 23 (telnet)
sudo ufw deny 23

# Bloquer un service
sudo ufw deny ftp
```

## Règles par adresse IP

### Autoriser depuis une IP spécifique

```bash
# Autoriser 192.168.1.50
sudo ufw allow from 192.168.1.50
```

### Autoriser un sous-réseau

```bash
# Autoriser tout le réseau 192.168.1.0/24
sudo ufw allow from 192.168.1.0/24
```

### Autoriser une IP vers un port spécifique

```bash
# 192.168.1.50 peut accéder au port 22
sudo ufw allow from 192.168.1.50 to any port 22
```

## Règles avancées

### Par interface réseau

```bash
# Autoriser sur eth0 uniquement
sudo ufw allow in on eth0 to any port 80
```

### Limiter les connexions (anti brute-force)

```bash
# Limite SSH (6 connexions en 30s max)
sudo ufw limit ssh
```

Bloque temporairement les IPs qui tentent trop de connexions.

## Voir les règles

### Format simplifié

```bash
sudo ufw status
```

### Format numéroté

```bash
sudo ufw status numbered
```

Affiche un numéro pour chaque règle :
```
     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere
[ 2] 80/tcp                     ALLOW IN    Anywhere
[ 3] 443/tcp                    ALLOW IN    Anywhere
```

### Format verbeux

```bash
sudo ufw status verbose
```

Affiche plus de détails (politique par défaut, logging).

## Supprimer des règles

### Par numéro

```bash
# Voir les numéros
sudo ufw status numbered

# Supprimer la règle 3
sudo ufw delete 3
```

### Par spécification

```bash
# Supprimer la règle qui autorise le port 80
sudo ufw delete allow 80

# Supprimer règle spécifique
sudo ufw delete allow from 192.168.1.50
```

## Politique par défaut

### Voir les politiques

```bash
sudo ufw status verbose
```

Par défaut :
- **Entrant** : DENY (bloqué)
- **Sortant** : ALLOW (autorisé)

### Modifier les politiques

```bash
# Bloquer tout le trafic entrant par défaut
sudo ufw default deny incoming

# Autoriser tout le trafic sortant
sudo ufw default allow outgoing

# Bloquer le trafic sortant (rare)
sudo ufw default deny outgoing
```

## Réinitialiser UFW

Supprimer toutes les règles :

```bash
sudo ufw reset
```

## Logging

### Activer les logs

```bash
sudo ufw logging on
```

### Niveaux de logging

```bash
sudo ufw logging low      # Minimal
sudo ufw logging medium   # Moyen (défaut)
sudo ufw logging high     # Détaillé
sudo ufw logging full     # Complet
```

### Voir les logs

```bash
sudo tail -f /var/log/ufw.log
```

## firewalld (alternative sur Fedora/RHEL)

Sur Fedora/RHEL, **firewalld** est utilisé.

### Commandes de base

```bash
# État
sudo firewall-cmd --state

# Lister les services autorisés
sudo firewall-cmd --list-all

# Autoriser un service
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload

# Autoriser un port
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# Bloquer une IP
sudo firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.100" reject' --permanent
sudo firewall-cmd --reload
```

### Zones

firewalld utilise des **zones** :

```bash
# Lister les zones
sudo firewall-cmd --get-zones

# Zone par défaut
sudo firewall-cmd --get-default-zone

# Changer de zone
sudo firewall-cmd --set-default-zone=public
```

## iptables (niveau bas)

UFW et firewalld sont des frontends pour **iptables**.

### Voir les règles iptables

```bash
sudo iptables -L -v -n
```

### Exemple de règle directe

```bash
# Autoriser port 8080
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
```

**Note** : Utilisez UFW/firewalld plutôt qu'iptables directement.

## Scénarios pratiques

### Serveur web basique

```bash
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

### Serveur de base de données

```bash
sudo ufw allow ssh
# MySQL accessible uniquement depuis 192.168.1.0/24
sudo ufw allow from 192.168.1.0/24 to any port 3306
sudo ufw enable
```

### Serveur de développement

```bash
sudo ufw allow ssh
sudo ufw allow 3000:3010/tcp  # Ports d'applications
sudo ufw allow 5432           # PostgreSQL
sudo ufw enable
```

## Tester le pare-feu

### Avant d'activer une règle

```bash
# Tester depuis une autre machine
nc -zv VOTRE_IP 80
```

### Scanner les ports ouverts

```bash
# Installer nmap
sudo apt install -y nmap

# Scanner localhost
sudo nmap localhost

# Scanner une machine distante
sudo nmap 192.168.1.100
```

## Bonnes pratiques

1. **Toujours autoriser SSH en premier** (serveurs distants)
2. **Politique par défaut stricte** : deny incoming, allow outgoing
3. **Principe du moindre privilège** : N'ouvrir que les ports nécessaires
4. **Utiliser limit pour SSH** : Protection brute-force
5. **Activer le logging** : Détecter les tentatives d'intrusion
6. **Restreindre par IP** quand possible
7. **Documenter** les règles

## Exercice pratique

1. Installez UFW :

```bash
sudo apt install -y ufw
```

2. Autorisez SSH (important!) :

```bash
sudo ufw allow ssh
```

3. Autorisez HTTP et HTTPS :

```bash
sudo ufw allow http
sudo ufw allow https
```

4. Activez le pare-feu :

```bash
sudo ufw enable
```

5. Vérifiez les règles :

```bash
sudo ufw status verbose
```

6. Créez le fichier de validation :

```bash
touch ~/parefeu_configure
```

Excellent ! Passons aux outils de téléchargement.
