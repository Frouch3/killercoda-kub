# Étape 5 : Analyser les connexions réseau

## Introduction

Pour déboguer les problèmes réseau et surveiller l'activité, il faut pouvoir **voir les connexions actives** et les ports en écoute.

## La commande ss (moderne)

**ss** (socket statistics) est l'outil moderne pour voir les connexions réseau.

### Toutes les connexions

```bash
ss
```

Affiche toutes les sockets (beaucoup d'informations!).

### Sockets en écoute

```bash
ss -l
```

Affiche les sockets en mode **LISTEN** (serveurs en attente de connexions).

### Connexions TCP

```bash
ss -t
```

### Connexions UDP

```bash
ss -u
```

### Combiner les options

```bash
# TCP en écoute
ss -lt

# UDP en écoute
ss -lu

# Toutes les connexions (établies + écoute)
ss -a
```

### Avec numéros de ports

```bash
ss -ltn
```

Options :
- `-n` : Affiche les numéros de ports (pas les noms de services)

### Avec les processus

```bash
sudo ss -ltnp
```

Option `-p` : Affiche le PID et nom du processus.

Exemple de sortie :
```
LISTEN  0  128  0.0.0.0:22   0.0.0.0:*  users:(("sshd",pid=1234,fd=3))
```

- Port **22** est en écoute
- Processus **sshd** avec PID **1234**

## Cas d'usage courants

### Voir tous les ports en écoute

```bash
sudo ss -ltnp
```

Identifiez rapidement ce qui écoute sur quelle port.

### Connexions établies

```bash
ss -tn state established
```

Voir toutes les connexions actives.

### Connexions vers un port spécifique

```bash
# Connexions vers le port 80
ss -tn sport = :80

# Connexions vers le port 443
ss -tn sport = :443
```

### Statistiques résumées

```bash
ss -s
```

Affiche un résumé :
- Total de sockets
- TCP en écoute
- TCP établies
- UDP
- etc.

## netstat (ancienne commande)

**netstat** est l'équivalent classique de ss.

### Installation

```bash
sudo apt install -y net-tools
```

### Utilisation similaire à ss

```bash
# Tous les ports en écoute
sudo netstat -ltn

# Avec les processus
sudo netstat -ltnp

# Connexions établies
netstat -tn

# Toutes les connexions
netstat -a
```

### Table de routage

```bash
netstat -r
```

Équivalent de `ip route show`.

### Statistiques par protocole

```bash
netstat -s
```

## lsof : List Open Files

**lsof** liste les fichiers ouverts, y compris les sockets réseau.

### Installer lsof

```bash
sudo apt install -y lsof
```

### Voir qui écoute sur un port

```bash
# Port 80
sudo lsof -i :80

# Port 22
sudo lsof -i :22
```

### Voir les connexions d'un processus

```bash
# Par nom
sudo lsof -c nginx

# Par PID
sudo lsof -p 1234
```

### Connexions réseau d'un utilisateur

```bash
sudo lsof -u www-data -i
```

## Identifier ce qui écoute sur un port

### Méthode 1 : ss

```bash
sudo ss -ltnp | grep :80
```

### Méthode 2 : lsof

```bash
sudo lsof -i :80
```

### Méthode 3 : fuser

```bash
sudo apt install -y psmisc
sudo fuser -n tcp 80
```

Affiche le PID du processus utilisant le port 80.

## Scanner les ports ouverts

### nmap (Network Mapper)

**nmap** est l'outil de référence pour scanner les ports.

```bash
# Installer nmap
sudo apt install -y nmap

# Scanner localhost
sudo nmap localhost

# Scanner une machine distante
sudo nmap 192.168.1.100

# Scan rapide (1000 ports courants)
nmap -F localhost

# Tous les ports TCP
nmap -p- localhost

# Détecter les services et versions
sudo nmap -sV localhost
```

### Scan UDP

```bash
sudo nmap -sU localhost
```

Plus lent car UDP ne garantit pas de réponse.

## Surveiller le trafic réseau

### iftop : Bande passante en temps réel

```bash
# Installer iftop
sudo apt install -y iftop

# Lancer
sudo iftop

# Sur une interface spécifique
sudo iftop -i eth0
```

Affiche les connexions actives et leur consommation de bande passante.

### nethogs : Bande passante par processus

```bash
# Installer nethogs
sudo apt install -y nethogs

# Lancer
sudo nethogs

# Sur une interface spécifique
sudo nethogs eth0
```

Identifie quel processus consomme le plus de bande passante.

### vnstat : Statistiques à long terme

```bash
# Installer vnstat
sudo apt install -y vnstat

# Initialiser
sudo vnstat -i eth0

# Voir les stats
vnstat

# Stats horaires
vnstat -h

# Stats journalières
vnstat -d

# Stats mensuelles
vnstat -m
```

## tcpdump : Capturer le trafic

**tcpdump** capture les paquets réseau (équivalent CLI de Wireshark).

### Capturer tout le trafic

```bash
sudo tcpdump -i eth0
```

**Attention** : Produit beaucoup de sortie !

### Capturer un nombre limité de paquets

```bash
sudo tcpdump -i eth0 -c 10
```

Capture 10 paquets puis s'arrête.

### Filtrer par port

```bash
# Port 80
sudo tcpdump -i eth0 port 80

# Port 443
sudo tcpdump -i eth0 port 443
```

### Filtrer par IP

```bash
# Trafic depuis/vers 192.168.1.100
sudo tcpdump -i eth0 host 192.168.1.100

# Trafic depuis cette IP
sudo tcpdump -i eth0 src 192.168.1.100

# Trafic vers cette IP
sudo tcpdump -i eth0 dst 192.168.1.100
```

### Sauvegarder dans un fichier

```bash
sudo tcpdump -i eth0 -w capture.pcap

# Lire le fichier
sudo tcpdump -r capture.pcap
```

Le fichier .pcap peut être analysé avec Wireshark.

### Afficher le contenu ASCII

```bash
sudo tcpdump -i eth0 -A port 80
```

Utile pour voir les requêtes HTTP en clair.

## Exemples de débogage

### Un service ne répond pas

```bash
# 1. Le service tourne ?
systemctl status nginx

# 2. Il écoute sur le bon port ?
sudo ss -ltnp | grep nginx

# 3. Le pare-feu bloque ?
sudo ufw status

# 4. Tester localement
curl -I localhost

# 5. Scanner les ports
nmap localhost
```

### Trop de connexions

```bash
# Compter les connexions par IP
ss -tn | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head -10
```

### Port déjà utilisé

```bash
# Qui utilise le port 8080 ?
sudo lsof -i :8080

# Tuer le processus si nécessaire
sudo kill -9 PID
```

### Connexion lente

```bash
# Vérifier la latence
ping -c 10 8.8.8.8

# Tracer la route
traceroute google.com

# Bande passante disponible
speedtest-cli  # Installer avec: pip install speedtest-cli
```

## Tableau récapitulatif des commandes

| Commande | Usage |
|----------|-------|
| `ss -ltnp` | Ports en écoute avec processus |
| `ss -tn state established` | Connexions établies |
| `netstat -ltnp` | Alternative à ss |
| `lsof -i :PORT` | Qui écoute sur un port |
| `nmap localhost` | Scanner les ports |
| `iftop` | Bande passante en temps réel |
| `nethogs` | Bande passante par processus |
| `tcpdump -i eth0 port 80` | Capturer le trafic |
| `ss -s` | Statistiques réseau |

## Exercice pratique

1. Listez tous les ports en écoute :

```bash
sudo ss -ltnp
```

2. Vérifiez que nginx écoute sur le port 80 :

```bash
sudo ss -ltnp | grep :80
```

3. Voyez les connexions établies :

```bash
ss -tn state established
```

4. Identifiez le processus sur le port 80 :

```bash
sudo lsof -i :80
```

5. Scannez les ports de localhost :

```bash
nmap localhost
```

6. Affichez les statistiques réseau :

```bash
ss -s
```

7. Créez le fichier de validation :

```bash
touch ~/connexions_analysees
```

Excellent ! Vous maîtrisez maintenant les outils réseau de base sous Linux.

## Bonnes pratiques

1. **Surveillez régulièrement** les ports en écoute
2. **Fermez les ports inutilisés** (sécurité)
3. **Documentez** les services en écoute
4. **Utilisez ss plutôt que netstat** (plus moderne)
5. **Capturez le trafic** seulement quand nécessaire (performance)
6. **Analysez les logs** en cas de problème
7. **Testez toujours localement** avant de blâmer le réseau

Félicitations ! Vous avez terminé ce scénario sur le réseau de base.
