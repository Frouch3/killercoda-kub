# Configuration réseau de base sous Linux

Bienvenue dans ce scénario de formation sur les bases du réseau sous Linux !

## Objectifs de cette formation

À la fin de ce scénario, vous serez capable de :

- **Vérifier la connectivité** avec ping et traceroute
- **Afficher la configuration réseau** avec ip et ifconfig
- **Comprendre les routes** et la table de routage
- **Configurer le pare-feu** avec ufw
- **Télécharger des fichiers** avec wget et curl
- **Analyser les connexions** avec ss et netstat
- **Diagnostiquer** les problèmes réseau courants

## Concepts clés

### Adresse IP
Une **adresse IP** identifie de manière unique un appareil sur un réseau :
- **IPv4** : 192.168.1.100 (format 32 bits)
- **IPv6** : 2001:db8::1 (format 128 bits)

### Masque de sous-réseau
Détermine quelle partie de l'adresse identifie le réseau :
- **255.255.255.0** ou **/24** : réseau de 254 hôtes

### Passerelle (Gateway)
Le **routeur** qui permet de sortir du réseau local vers Internet.

### DNS
Traduit les noms de domaine (google.com) en adresses IP.

### Ports
Les applications communiquent via des **ports** :
- Port 22 : SSH
- Port 80 : HTTP
- Port 443 : HTTPS
- Port 3306 : MySQL

## Pourquoi c'est important ?

La compréhension du réseau est essentielle pour :
- Diagnostiquer les problèmes de connectivité
- Sécuriser les serveurs
- Configurer des applications web
- Administrer des serveurs distants

## Prérequis

- Connaissances de base en ligne de commande Linux
- Avoir suivi les scénarios précédents

## Durée estimée

30 à 40 minutes

Commençons par vérifier la connectivité réseau !
