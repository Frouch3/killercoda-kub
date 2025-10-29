# Félicitations !

Vous avez terminé le scénario sur la configuration réseau de base sous Linux !

## Ce que vous avez appris

### Tests de connectivité
- **ping** : Tester la connectivité ICMP
- **traceroute** : Tracer le chemin des paquets
- **telnet** / **nc** : Tester les ports TCP
- **nslookup** / **dig** / **host** : Résolution DNS
- **curl** : Tester les connexions HTTP/HTTPS

### Configuration réseau
- **ip** : Outil moderne de configuration (addr, link, route)
- **ifconfig** : Outil classique (obsolète mais encore utilisé)
- **hostname** / **hostnamectl** : Gestion du nom d'hôte
- **/etc/hosts** : Résolution DNS locale
- **/etc/resolv.conf** : Serveurs DNS
- **netplan** : Configuration réseau moderne (Ubuntu)
- **NetworkManager** : Gestion réseau desktop

### Pare-feu
- **ufw** : Pare-feu simple (Ubuntu/Debian)
- **firewalld** : Pare-feu Fedora/RHEL
- **iptables** : Pare-feu bas niveau
- Règles par port, IP, service
- Politiques par défaut
- Protection brute-force avec limit

### Téléchargement
- **wget** : Télécharger des fichiers
- **curl** : Interagir avec des APIs REST
- Reprendre des téléchargements
- Authentification
- Téléchargements récursifs

### Analyse des connexions
- **ss** : Socket statistics (moderne)
- **netstat** : Statistiques réseau (classique)
- **lsof** : Fichiers et sockets ouverts
- **nmap** : Scanner de ports
- **iftop** / **nethogs** : Bande passante
- **tcpdump** : Capture de paquets

## Commandes essentielles à retenir

```bash
# Tests de base
ping -c 4 8.8.8.8              # Test connectivité
traceroute google.com          # Tracer route
nslookup google.com            # Résoudre DNS
curl -I https://example.com    # Test HTTP

# Configuration
ip addr show                   # Afficher IPs
ip route show                  # Table de routage
hostname                       # Nom d'hôte
cat /etc/resolv.conf          # Serveurs DNS

# Pare-feu (UFW)
sudo ufw status               # État pare-feu
sudo ufw allow 80            # Ouvrir port
sudo ufw deny 23             # Bloquer port
sudo ufw enable              # Activer

# Téléchargement
wget URL                      # Télécharger
wget -c URL                   # Reprendre
curl -O URL                   # Télécharger avec curl
curl -I URL                   # Headers seulement

# Connexions
sudo ss -ltnp                 # Ports en écoute
ss -tn state established      # Connexions actives
sudo lsof -i :80             # Qui écoute sur port 80
nmap localhost               # Scanner ports
```

## Diagnostic réseau : checklist

Quand le réseau ne fonctionne pas :

1. **Interface up ?**
   ```bash
   ip link show
   ```

2. **IP configurée ?**
   ```bash
   ip addr show
   ```

3. **Route par défaut ?**
   ```bash
   ip route show
   ```

4. **Gateway accessible ?**
   ```bash
   ping $(ip route | grep default | awk '{print $3}')
   ```

5. **DNS fonctionne ?**
   ```bash
   nslookup google.com
   ```

6. **Internet accessible ?**
   ```bash
   ping -c 3 8.8.8.8
   ```

7. **Pare-feu bloque ?**
   ```bash
   sudo ufw status
   ```

8. **Service écoute ?**
   ```bash
   sudo ss -ltnp | grep :80
   ```

## Bonnes pratiques de sécurité

1. **Pare-feu toujours actif** sur les serveurs
2. **N'ouvrir que les ports nécessaires**
3. **Bloquer par défaut**, autoriser spécifiquement
4. **Utiliser limit pour SSH** (anti brute-force)
5. **Surveiller les connexions** régulièrement
6. **Mettre à jour** les règles firewall documentées
7. **Tester avant de déployer** en production
8. **Restreindre par IP** quand possible
9. **Désactiver les services inutiles**
10. **Auditer les ports ouverts** périodiquement

## Outils avancés pour aller plus loin

### Monitoring réseau
- **Wireshark** : Analyse de paquets GUI
- **ntop** / **ntopng** : Monitoring réseau complet
- **Zabbix** / **Nagios** : Supervision serveur
- **Prometheus** + **Grafana** : Métriques et dashboards

### Sécurité
- **fail2ban** : Bloquer IPs malveillantes
- **OSSEC** / **Wazuh** : Détection d'intrusion
- **Snort** / **Suricata** : IDS/IPS
- **nftables** : Remplaçant moderne d'iptables

### Performance
- **iperf** : Tester la bande passante
- **mtr** : Combinaison ping + traceroute
- **ethtool** : Configuration interfaces
- **tc** : Traffic control (QoS)

### VPN et tunnels
- **OpenVPN** : VPN open source
- **WireGuard** : VPN moderne et rapide
- **SSH tunneling** : Tunnels sécurisés
- **stunnel** : Tunnels TLS

## Scénarios réseau courants

### Serveur web public

```bash
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

### Serveur de développement

```bash
sudo ufw allow ssh
sudo ufw allow 3000:9000/tcp
sudo ufw allow from 192.168.1.0/24
sudo ufw enable
```

### Base de données sécurisée

```bash
sudo ufw allow ssh
sudo ufw allow from 192.168.1.0/24 to any port 5432
sudo ufw deny 5432
sudo ufw enable
```

## Ressources utiles

- `man ip` : Manuel complet de ip
- `man ss` : Manuel de ss
- `man ufw` : Manuel d'ufw
- `man curl` : Manuel de curl
- [netfilter.org](https://www.netfilter.org/) : Documentation iptables/nftables

## Dépannage courant

### Pas d'accès Internet

```bash
# Vérifier gateway
ip route show
ping $(ip route | grep default | awk '{print $3}')

# Vérifier DNS
cat /etc/resolv.conf
nslookup google.com

# Redémarrer réseau
sudo systemctl restart NetworkManager
```

### Port déjà utilisé

```bash
sudo lsof -i :8080
sudo kill -9 PID
# ou changer le port de l'application
```

### Connexion refusée

```bash
# Service actif ?
systemctl status nginx

# Écoute sur le bon port ?
sudo ss -ltnp | grep nginx

# Pare-feu ?
sudo ufw status
```

## Prochaines étapes

Continuez votre apprentissage avec :
- **Scénario 08** : Scripts et automatisation bash

Les compétences réseau sont **essentielles** pour tout administrateur système et développeur. Vous êtes maintenant capable de diagnostiquer et résoudre la plupart des problèmes réseau courants !

Merci d'avoir suivi ce scénario et bon courage pour la suite !
