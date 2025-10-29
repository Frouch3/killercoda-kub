# Étape 4 : Télécharger et tester avec wget et curl

## Introduction

**wget** et **curl** sont deux outils essentiels pour télécharger des fichiers et interagir avec des APIs depuis la ligne de commande.

## wget : le téléchargeur

**wget** (Web GET) télécharge des fichiers depuis le web.

### Installation (si nécessaire)

```bash
sudo apt install -y wget
```

### Télécharger un fichier

```bash
wget https://example.com/fichier.txt
```

Le fichier est sauvegardé dans le répertoire actuel.

### Télécharger avec un nom différent

```bash
wget -O mon_fichier.txt https://example.com/fichier.txt
```

### Télécharger dans un répertoire spécifique

```bash
wget -P /tmp https://example.com/fichier.txt
```

### Télécharger en arrière-plan

```bash
wget -b https://example.com/gros_fichier.iso
```

Le téléchargement continue même si vous fermez le terminal.

Voir la progression :

```bash
tail -f wget-log
```

### Reprendre un téléchargement interrompu

```bash
wget -c https://example.com/gros_fichier.iso
```

L'option `-c` (continue) reprend là où ça s'était arrêté.

### Limiter la vitesse de téléchargement

```bash
# Limiter à 200K/s
wget --limit-rate=200k https://example.com/fichier.txt
```

### Télécharger récursivement un site

```bash
# Télécharger tout un site (attention!)
wget -r -np -k https://example.com/docs/

# Options:
# -r : récursif
# -np : ne pas remonter dans les répertoires parents
# -k : convertir les liens pour navigation locale
```

### Télécharger avec authentification

```bash
wget --user=utilisateur --password=motdepasse https://example.com/secure/fichier.txt
```

### Exemple pratique

Téléchargeons un fichier de test :

```bash
cd ~
wget https://www.kernel.org/pub/linux/kernel/v6.x/README
cat README
```

## curl : l'outil polyvalent

**curl** est plus flexible que wget et supporte de nombreux protocoles.

### Installation (généralement déjà installé)

```bash
sudo apt install -y curl
```

### Afficher le contenu d'une URL

```bash
curl https://example.com
```

Affiche le HTML dans le terminal.

### Sauvegarder dans un fichier

```bash
# Option -o (output)
curl -o fichier.html https://example.com

# Option -O (garde le nom du fichier distant)
curl -O https://example.com/fichier.txt
```

### Suivre les redirections

```bash
curl -L https://github.com
```

L'option `-L` suit les redirections HTTP.

### Voir seulement les headers

```bash
curl -I https://example.com
```

Affiche les headers HTTP (code de statut, type de contenu, etc.)

### Télécharger avec une barre de progression

```bash
curl -# -O https://example.com/fichier.zip
```

### Mode silencieux

```bash
curl -s https://example.com
```

Pas de barre de progression ni messages d'erreur.

### Reprendre un téléchargement

```bash
curl -C - -O https://example.com/gros_fichier.iso
```

## Interagir avec des APIs

### Requête GET

```bash
curl https://api.github.com/users/torvalds
```

### Requête POST

```bash
curl -X POST -d "nom=Test&email=test@example.com" https://httpbin.org/post
```

### POST avec JSON

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"nom":"Test","email":"test@example.com"}' \
  https://httpbin.org/post
```

### Authentification

```bash
# Basic auth
curl -u utilisateur:motdepasse https://example.com/api

# Bearer token
curl -H "Authorization: Bearer TON_TOKEN" https://api.example.com/data
```

### Envoyer des fichiers

```bash
curl -F "fichier=@/chemin/fichier.txt" https://httpbin.org/post
```

## Tester des endpoints

### Code de statut HTTP uniquement

```bash
curl -s -o /dev/null -w "%{http_code}" https://example.com
```

### Temps de réponse

```bash
curl -s -o /dev/null -w "Temps total: %{time_total}s\n" https://example.com
```

### Détails complets

```bash
curl -w "\nCode: %{http_code}\nTemps: %{time_total}s\nTaille: %{size_download} bytes\n" \
  -o /dev/null -s https://example.com
```

## Télécharger depuis plusieurs sources

### wget : liste d'URLs

Créer un fichier `urls.txt` :

```bash
cat > urls.txt << EOF
https://example.com/file1.txt
https://example.com/file2.txt
https://example.com/file3.txt
EOF

wget -i urls.txt
```

### curl : plusieurs URLs en parallèle

```bash
curl -O https://example.com/file1.txt \
     -O https://example.com/file2.txt \
     -O https://example.com/file3.txt
```

## Vérifier la disponibilité d'un site

### Test simple

```bash
curl -I https://google.com
```

Si code 200, le site est accessible.

### Script de monitoring

```bash
#!/bin/bash
URL="https://example.com"
CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ $CODE -eq 200 ]; then
    echo "✓ $URL est accessible"
else
    echo "✗ $URL retourne le code $CODE"
fi
```

## Proxy et options avancées

### Utiliser un proxy

```bash
# wget
wget -e use_proxy=yes -e http_proxy=192.168.1.1:8080 https://example.com

# curl
curl -x 192.168.1.1:8080 https://example.com
```

### Ignorer les erreurs SSL (development seulement!)

```bash
# wget
wget --no-check-certificate https://expired.badssl.com/

# curl
curl -k https://expired.badssl.com/
```

**Attention** : Ne pas utiliser en production !

### User-Agent personnalisé

```bash
# wget
wget --user-agent="Mon-Bot/1.0" https://example.com

# curl
curl -A "Mon-Bot/1.0" https://example.com
```

### Timeout

```bash
# wget
wget --timeout=10 https://example.com

# curl
curl --max-time 10 https://example.com
```

## Comparaison wget vs curl

| Fonctionnalité | wget | curl |
|----------------|------|------|
| Téléchargement simple | ✓ | ✓ |
| Téléchargement récursif | ✓ | ✗ |
| Reprendre téléchargement | ✓ | ✓ |
| Protocoles supportés | HTTP, HTTPS, FTP | HTTP, HTTPS, FTP, SFTP, SCP, SMTP, etc. |
| APIs REST | Limité | ✓ Excellent |
| Upload de fichiers | ✗ | ✓ |
| Cookies | ✓ | ✓ |
| Simplicité téléchargement | ✓✓ | ✓ |

**Recommandation** :
- **wget** pour télécharger des fichiers
- **curl** pour interagir avec des APIs

## Exemples pratiques

### Télécharger un script et l'exécuter

```bash
curl -fsSL https://get.docker.com | sh
```

Options :
- `-f` : fail silently on errors
- `-s` : silent mode
- `-S` : show errors
- `-L` : follow redirects

### Télécharger la dernière release GitHub

```bash
# Récupérer l'URL de la dernière release
LATEST=$(curl -s https://api.github.com/repos/user/repo/releases/latest | grep "browser_download_url" | cut -d '"' -f 4)

# Télécharger
wget $LATEST
```

### Tester une API REST

```bash
# GET
curl https://jsonplaceholder.typicode.com/posts/1

# POST
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","body":"Contenu","userId":1}' \
  https://jsonplaceholder.typicode.com/posts

# PUT
curl -X PUT \
  -H "Content-Type: application/json" \
  -d '{"title":"Modifié"}' \
  https://jsonplaceholder.typicode.com/posts/1

# DELETE
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

## Exercice pratique

1. Téléchargez un fichier avec wget :

```bash
cd ~/
wget https://www.kernel.org/pub/linux/kernel/v6.x/README
```

2. Vérifiez qu'il est téléchargé :

```bash
ls -lh README
```

3. Testez une API avec curl :

```bash
curl -s https://api.github.com/users/torvalds | head -20
```

4. Récupérez le code HTTP d'un site :

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://google.com
```

5. Téléchargez avec curl et sauvegardez :

```bash
curl -o test.json https://jsonplaceholder.typicode.com/posts/1
cat test.json
```

6. Créez le fichier de validation :

```bash
touch ~/telechargements_testes
```

Parfait ! Passons maintenant à l'analyse des connexions réseau actives.
