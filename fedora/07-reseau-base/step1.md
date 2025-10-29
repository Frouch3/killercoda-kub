# Étape 1 : Vérifier la connectivité réseau

## Introduction

Avant toute configuration, il faut **vérifier la connectivité** réseau. Plusieurs outils permettent de tester si vous pouvez joindre d'autres machines.

## La commande ping

**ping** envoie des paquets ICMP pour tester la connectivité.

### Syntaxe de base

```bash
ping adresse
```

### Tester la connectivité Internet

```bash
# Ping Google DNS
ping -c 4 8.8.8.8
```

Options :
- `-c 4` : Envoyer 4 paquets puis s'arrêter
- Sans `-c` : Ping continu (Ctrl+C pour arrêter)

Résultat :
```
64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=15.2 ms
```

- **icmp_seq** : Numéro de séquence
- **ttl** : Time To Live (nombre de sauts restants)
- **time** : Temps de réponse (latence)

### Tester avec un nom de domaine

```bash
ping -c 3 google.com
```

Si ça fonctionne, votre **résolution DNS** marche aussi !

### Ping vers localhost

```bash
# Teste la pile réseau locale
ping -c 2 localhost

# Ou avec l'IP de loopback
ping -c 2 127.0.0.1
```

Si ça ne marche pas, problème de configuration réseau de base.

## Interpréter les résultats de ping

### Succès

```
4 packets transmitted, 4 received, 0% packet loss
```

Tout va bien !

### Perte de paquets

```
4 packets transmitted, 2 received, 50% packet loss
```

Problème de stabilité réseau.

### Échec total

```
ping: connect: Network is unreachable
```

Pas de route vers la destination (pas de gateway, pas d'interface up).

```
ping: google.com: Name or service not known
```

Problème DNS.

## La commande traceroute

**traceroute** affiche le chemin des paquets jusqu'à la destination.

### Installation (si nécessaire)

```bash
sudo apt update
sudo apt install -y traceroute
```

### Utilisation

```bash
traceroute google.com
```

Affiche chaque **routeur** (hop) traversé :

```
 1  192.168.1.1 (192.168.1.1)  2.145 ms
 2  10.0.0.1 (10.0.0.1)  10.23 ms
 3  * * *
 4  172.217.16.206 (172.217.16.206)  25.67 ms
```

- Chaque ligne = un saut (hop)
- `* * *` = pas de réponse (firewall bloque ICMP)
- Temps = latence jusqu'à ce routeur

### Alternative : tracepath

Plus simple, ne nécessite pas root :

```bash
tracepath google.com
```

## Tester un port spécifique avec telnet

**telnet** teste si un port est ouvert :

```bash
# Installer telnet si nécessaire
sudo apt install -y telnet

# Tester le port 80 de Google
telnet google.com 80
```

Si connexion réussie :
```
Trying 142.250.185.46...
Connected to google.com.
```

Tapez quelque chose puis Ctrl+] et `quit`.

Si échec :
```
telnet: Unable to connect to remote host: Connection refused
```

## Alternative moderne : nc (netcat)

**nc** (netcat) est plus puissant :

```bash
# Tester un port
nc -zv google.com 80

# Options:
# -z : scan sans envoyer de données
# -v : verbose (détaillé)
```

Résultat :
```
Connection to google.com 80 port [tcp/http] succeeded!
```

### Tester plusieurs ports

```bash
# Ports 80 à 85
nc -zv google.com 80-85
```

## Résolution DNS avec nslookup et dig

### nslookup

```bash
# Résoudre un nom de domaine
nslookup google.com
```

Affiche :
- Le serveur DNS utilisé
- L'adresse IP correspondante

### dig (plus détaillé)

```bash
# Installer dig
sudo apt install -y dnsutils

# Résoudre google.com
dig google.com
```

Plus complet : type d'enregistrement (A, AAAA, MX, etc.)

### dig simple

```bash
# Juste l'IP
dig +short google.com
```

### Résolution inverse

```bash
# De l'IP vers le nom
dig -x 8.8.8.8
```

## host : résolution DNS simple

```bash
host google.com
host 8.8.8.8
```

## Tester la connectivité HTTP

### Avec curl (préféré)

```bash
# Récupérer juste les headers HTTP
curl -I https://google.com

# Code de statut uniquement
curl -s -o /dev/null -w "%{http_code}" https://google.com
```

### Mesurer le temps de réponse

```bash
curl -o /dev/null -s -w "Time: %{time_total}s\n" https://google.com
```

## Vérifier la passerelle (gateway)

### Afficher la route par défaut

```bash
ip route show
```

Recherchez la ligne `default via` :
```
default via 192.168.1.1 dev eth0
```

- **192.168.1.1** = votre passerelle (routeur)
- **eth0** = interface réseau utilisée

### Tester la passerelle

```bash
# Remplacez par votre IP de gateway
ping -c 3 192.168.1.1
```

Si ça ne marche pas, problème avec votre routeur local.

## Diagnostic rapide de connectivité

### Checklist

1. **Interface réseau up ?**
   ```bash
   ip link show
   ```

2. **Adresse IP configurée ?**
   ```bash
   ip addr show
   ```

3. **Gateway joignable ?**
   ```bash
   ip route show
   ping -c 3 $(ip route show | grep default | awk '{print $3}')
   ```

4. **DNS fonctionne ?**
   ```bash
   nslookup google.com
   ```

5. **Internet accessible ?**
   ```bash
   ping -c 3 8.8.8.8
   ```

## Exercice pratique

1. Testez la connectivité vers Google :

```bash
ping -c 4 google.com
```

2. Résolvez le nom de domaine :

```bash
nslookup google.com
```

3. Testez le port 80 :

```bash
nc -zv google.com 80
```

4. Affichez votre route par défaut :

```bash
ip route show
```

5. Créez le fichier de validation :

```bash
touch ~/connectivite_testee
```

Excellent ! Passons maintenant à la configuration réseau.
