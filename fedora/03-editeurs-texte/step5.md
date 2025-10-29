# Étape 5 : Éditer des fichiers de configuration

## Pourquoi éditer des fichiers de configuration ?

Sous Linux, la plupart des configurations se font en éditant des fichiers texte :
- Configuration système (`/etc`)
- Configuration d'applications
- Scripts personnalisés
- Fichiers de logs

Savoir bien utiliser un éditeur est **essentiel** pour tout administrateur Linux !

## Fichier .bashrc - Personnaliser votre shell

Le fichier `~/.bashrc` configure votre terminal bash.

### Éditer avec nano

```bash
nano ~/.bashrc
```

Allez à la fin du fichier (`Ctrl+End` ou `Alt+/`) et ajoutez :

```bash
# === Mes personnalisations ===

# Alias utiles
alias ll='ls -lah'
alias c='clear'
alias ..='cd ..'
alias update='sudo apt update && sudo apt upgrade'

# Prompt personnalisé coloré
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Message de bienvenue
echo "Bienvenue $(whoami) ! Il est $(date +%H:%M)"
```

Sauvegardez (`Ctrl+O`, `Entrée`, `Ctrl+X`).

Rechargez la configuration :
```bash
source ~/.bashrc
```

Testez vos alias :
```bash
ll          # Liste détaillée
c           # Clear l'écran
..          # Remonter d'un dossier
```

### Éditer avec vim

```bash
vim ~/.bashrc
```

1. Tapez `G` pour aller à la fin
2. Tapez `o` pour nouvelle ligne
3. Mode INSERTION, ajoutez :
```bash
# Historique amélioré
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%d/%m/%y %T "
```
4. `Esc`, puis `:wq`

Rechargez :
```bash
source ~/.bashrc
```

## Créer un fichier de configuration d'application

### Exemple : Configuration serveur web

```bash
mkdir -p ~/config
nano ~/config/webapp.conf
```

Créez une configuration complète :
```ini
# Configuration de l'application web
[general]
app_name = MonApp
version = 1.0.0
environment = production

[server]
host = 0.0.0.0
port = 8080
workers = 4
timeout = 30

[database]
type = postgresql
host = localhost
port = 5432
name = myapp_db
user = app_user
password = changeme_in_production

[security]
secret_key = your-secret-key-here
session_timeout = 3600
csrf_protection = true
https_only = true

[logging]
level = INFO
file = /var/log/myapp/app.log
max_size = 100MB
backup_count = 5

[cache]
type = redis
host = localhost
port = 6379
ttl = 300
```

Sauvegardez (`Ctrl+O`, `Entrée`, `Ctrl+X`).

## Éditer des fichiers système (avec sudo)

Certains fichiers nécessitent des droits administrateur.

### Éditer /etc/hosts

```bash
sudo nano /etc/hosts
```

Ou avec vim :
```bash
sudo vim /etc/hosts
```

Ajoutez des alias locaux à la fin :
```
# Mes alias personnalisés
127.0.0.1   dev.local
127.0.0.1   api.local
127.0.0.1   admin.local
```

⚠️ **Attention** : Soyez prudent avec les fichiers système ! Une erreur peut rendre le système instable.

## Comparer nano vs vim pour les configs

### Utilisez nano quand :
- ✅ Vous faites une modification rapide
- ✅ Vous débutez sous Linux
- ✅ Le fichier est court
- ✅ Vous voulez de la simplicité

### Utilisez vim quand :
- ✅ Vous éditez souvent le même fichier
- ✅ Le fichier est long (plusieurs centaines de lignes)
- ✅ Vous devez faire beaucoup de recherche/remplacement
- ✅ Vous êtes sur un serveur distant (vim est toujours présent)

## Exercice pratique : Configuration complète

### 1. Créer une structure de configuration

```bash
mkdir -p ~/projets/mon_app/{config,logs,data}
```

### 2. Créer un fichier .env (variables d'environnement)

```bash
nano ~/projets/mon_app/.env
```

Contenu :
```bash
# Variables d'environnement
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USER=developer
DB_PASSWORD=dev123

# API Keys (NE JAMAIS commiter en production !)
API_KEY=votre_cle_api
SECRET_TOKEN=votre_token_secret

# Features flags
ENABLE_DEBUG=true
ENABLE_CACHE=false
```

### 3. Créer un README avec vim

```bash
vim ~/projets/mon_app/README.md
```

Mode INSERTION, tapez :
```markdown
# Mon Application

## Description
Ceci est mon application de test pour apprendre Linux.

## Configuration

### Installation
\```bash
cd ~/projets/mon_app
cp .env.example .env
nano .env  # Modifier les variables
\```

### Variables d'environnement
Voir le fichier `.env` pour toutes les options disponibles.

### Lancer l'application
\```bash
./start.sh
\```

## Structure du projet
\```
mon_app/
├── config/     # Fichiers de configuration
├── logs/       # Fichiers de logs
├── data/       # Données de l'application
├── .env        # Variables d'environnement
└── README.md   # Ce fichier
\```

## Maintenance

### Voir les logs
\```bash
tail -f logs/app.log
\```

### Nettoyer les logs
\```bash
rm logs/*.log
\```

## Auteur
Votre nom - $(date +%Y)
```

Sauvegardez (`:wq`).

### 4. Créer un script de démarrage

```bash
vim ~/projets/mon_app/start.sh
```

Contenu :
```bash
#!/bin/bash

# Script de démarrage de l'application

# Charger les variables d'environnement
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "❌ Fichier .env manquant !"
    exit 1
fi

# Vérifier la configuration
echo "🔍 Vérification de la configuration..."
echo "   - Environment: $NODE_ENV"
echo "   - Port: $PORT"
echo "   - Database: $DB_HOST:$DB_PORT/$DB_NAME"

# Créer le dossier logs si nécessaire
mkdir -p logs

# Message de démarrage
echo "✅ Configuration OK"
echo "🚀 Démarrage de l'application sur le port $PORT"

# Ici vous lanceriez votre application
# node server.js >> logs/app.log 2>&1 &
echo "Application démarrée (simulation)"
```

Sauvegardez et rendez exécutable :
```bash
chmod +x ~/projets/mon_app/start.sh
```

### 5. Tester le script

```bash
cd ~/projets/mon_app
./start.sh
```

## Bonnes pratiques pour les fichiers de configuration

✅ **À FAIRE** :
- Toujours faire une sauvegarde avant modification
- Commenter vos modifications avec date et raison
- Utiliser des fichiers `.example` pour les templates
- Vérifier la syntaxe après modification
- Tester sur un environnement de dev d'abord

❌ **À NE PAS FAIRE** :
- Modifier des fichiers système sans backup
- Mettre des mots de passe en dur en production
- Commiter des fichiers `.env` avec des secrets
- Éditer sans comprendre ce que fait chaque ligne

## Sauvegarder avant modification

Toujours faire une copie avant de modifier un fichier important :

```bash
# Avec date dans le nom
sudo cp /etc/hosts /etc/hosts.backup.$(date +%Y%m%d)

# Ou simplement
sudo cp /etc/hosts /etc/hosts.bak
```

## Vérifier la syntaxe

Pour certains fichiers, vous pouvez vérifier la syntaxe :

```bash
# Configuration Apache
sudo apache2ctl configtest

# Configuration Nginx
sudo nginx -t

# Script bash
bash -n script.sh

# JSON
python3 -m json.tool config.json

# YAML
python3 -c 'import yaml; yaml.safe_load(open("config.yaml"))'
```

## Résumé

```bash
# Éditer avec nano
nano fichier.conf
sudo nano /etc/fichier.conf

# Éditer avec vim
vim fichier.conf
sudo vim /etc/fichier.conf

# Sauvegarder avant modification
cp fichier.conf fichier.conf.bak
sudo cp /etc/fichier /etc/fichier.bak.$(date +%Y%m%d)

# Recharger une configuration shell
source ~/.bashrc

# Comparer deux fichiers
diff fichier1.conf fichier2.conf
```

## Quel éditeur choisir ?

Pour débuter : **nano**
- Simple et intuitif
- Parfait pour les modifications rapides

À long terme : **vim**
- Plus puissant et efficace
- Omniprésent sur tous les serveurs
- Vaut l'investissement d'apprentissage

💡 **Conseil** : Maîtrisez les deux ! Utilisez nano pour la simplicité, vim pour l'efficacité.

---

✅ Pratiquez l'édition de fichiers de configuration, vous êtes maintenant prêt pour les scénarios suivants !
