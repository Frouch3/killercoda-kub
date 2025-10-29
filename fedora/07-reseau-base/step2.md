# Étape 2 : Configuration réseau de base

## Introduction

Linux offre plusieurs outils pour configurer le réseau. Nous allons voir les commandes modernes (`ip`) et classiques (`ifconfig`).

## La commande ip (moderne)

**ip** est l'outil moderne pour gérer le réseau sous Linux.

### Afficher toutes les interfaces

```bash
ip link show
```

Affiche les interfaces réseau :
- **lo** : loopback (127.0.0.1)
- **eth0** : ethernet
- **wlan0** : wifi
- **docker0** : pont Docker

États possibles :
- **UP** : Interface activée
- **DOWN** : Interface désactivée

### Afficher les adresses IP

```bash
ip addr show
```

ou en abrégé :

```bash
ip a
```

Exemple de sortie :
```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
    inet 192.168.1.100/24 brd 192.168.1.255 scope global eth0
    inet6 fe80::a00:27ff:fe4e:66a1/64 scope link
```

- **inet** : IPv4
- **/24** : masque de sous-réseau (255.255.255.0)
- **brd** : adresse de broadcast
- **inet6** : IPv6

### Afficher une interface spécifique

```bash
ip addr show eth0
ip addr show lo
```

### Activer/Désactiver une interface

```bash
# Désactiver
sudo ip link set eth0 down

# Activer
sudo ip link set eth0 up
```

**Attention** : Désactiver votre interface réseau principale vous déconnecte !

## Afficher la table de routage

```bash
ip route show
```

ou :

```bash
ip r
```

Sortie typique :
```
default via 192.168.1.1 dev eth0 proto dhcp metric 100
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100
```

Explications :
- **default via 192.168.1.1** : Route par défaut (gateway)
- **dev eth0** : Via l'interface eth0
- **192.168.1.0/24** : Réseau local

## Configuration temporaire d'une IP

### Ajouter une adresse IP

```bash
sudo ip addr add 192.168.1.200/24 dev eth0
ip addr show eth0
```

L'interface a maintenant 2 IPs.

### Supprimer une adresse IP

```bash
sudo ip addr del 192.168.1.200/24 dev eth0
ip addr show eth0
```

**Note** : Ces modifications sont **temporaires** (perdues au reboot).

## Ajouter une route

### Route par défaut (gateway)

```bash
sudo ip route add default via 192.168.1.1 dev eth0
```

### Route vers un réseau spécifique

```bash
sudo ip route add 10.0.0.0/24 via 192.168.1.254 dev eth0
```

### Supprimer une route

```bash
sudo ip route del 10.0.0.0/24
```

## L'ancienne commande ifconfig

**ifconfig** est obsolète mais encore utilisé.

### Installation (si nécessaire)

```bash
sudo apt install -y net-tools
```

### Afficher les interfaces

```bash
ifconfig
```

### Afficher une interface spécifique

```bash
ifconfig eth0
```

### Activer/Désactiver

```bash
sudo ifconfig eth0 down
sudo ifconfig eth0 up
```

### Configurer une IP (temporaire)

```bash
sudo ifconfig eth0 192.168.1.200 netmask 255.255.255.0
```

## Nom d'hôte (hostname)

### Afficher le nom d'hôte

```bash
hostname
```

### Afficher le FQDN (nom complet)

```bash
hostname -f
```

### Changer temporairement

```bash
sudo hostname nouveau-nom
```

### Changer définitivement

```bash
# Éditer le fichier
sudo nano /etc/hostname

# Ou utiliser hostnamectl
sudo hostnamectl set-hostname nouveau-nom
```

Vérifier :

```bash
hostnamectl status
```

## Fichier /etc/hosts

Le fichier **/etc/hosts** permet de définir des résolutions DNS locales.

### Voir le contenu

```bash
cat /etc/hosts
```

Contenu typique :
```
127.0.0.1       localhost
127.0.1.1       monserveur
192.168.1.50    serveur-web
```

### Ajouter une entrée

```bash
echo "192.168.1.100 monapp.local" | sudo tee -a /etc/hosts
```

Maintenant `monapp.local` pointe vers 192.168.1.100 :

```bash
ping -c 2 monapp.local
```

## Configuration DNS

### Fichier /etc/resolv.conf

Contient les serveurs DNS :

```bash
cat /etc/resolv.conf
```

Exemple :
```
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
```

### Modifier (temporaire)

```bash
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
```

**Note** : Souvent écrasé par NetworkManager ou systemd-resolved.

### Configuration permanente (Ubuntu/systemd)

Utiliser **systemd-resolved** :

```bash
sudo nano /etc/systemd/resolved.conf
```

Ajouter :
```
[Resolve]
DNS=1.1.1.1 8.8.8.8
```

Redémarrer :

```bash
sudo systemctl restart systemd-resolved
```

## NetworkManager

Sur desktop Ubuntu, **NetworkManager** gère le réseau.

### État

```bash
systemctl status NetworkManager
```

### Outil CLI : nmcli

```bash
# Lister les connexions
nmcli connection show

# Détails d'une connexion
nmcli connection show "Wired connection 1"

# Activer/désactiver le réseau
nmcli networking on
nmcli networking off
```

## netplan (Ubuntu moderne)

Ubuntu récent utilise **netplan** pour la config réseau.

### Fichiers de configuration

```bash
ls /etc/netplan/
cat /etc/netplan/*.yaml
```

Exemple de config DHCP :

```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
```

Exemple de config IP statique :

```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

### Appliquer la config

```bash
sudo netplan apply
```

### Tester avant d'appliquer

```bash
sudo netplan try
```

Applique la config pendant 120s. Si pas confirmé, revient à l'ancienne config.

## Vérifier la configuration actuelle

### Résumé complet

```bash
# Interfaces et IPs
ip addr show

# Routes
ip route show

# DNS
cat /etc/resolv.conf

# Hostname
hostname -f
```

## Exercice pratique

1. Affichez vos interfaces réseau :

```bash
ip addr show
```

2. Affichez la table de routage :

```bash
ip route show
```

3. Vérifiez votre nom d'hôte :

```bash
hostname
```

4. Vérifiez vos serveurs DNS :

```bash
cat /etc/resolv.conf
```

5. Ajoutez une entrée dans /etc/hosts :

```bash
echo "127.0.0.1 test.local" | sudo tee -a /etc/hosts
```

6. Testez-la :

```bash
ping -c 2 test.local
```

7. Créez le fichier de validation :

```bash
touch ~/config_reseau_ok
```

Parfait ! Passons maintenant à la configuration du pare-feu.
