# Étape 4 : Gérer les services avec systemctl

## Introduction

Maintenant que nous comprenons systemd, apprenons à **manipuler les services** : les démarrer, arrêter, redémarrer et configurer leur démarrage automatique.

## Commandes essentielles

### Démarrer un service

```bash
sudo systemctl start nom_service
```

Démarre le service **immédiatement** (n'affecte pas le démarrage auto).

### Arrêter un service

```bash
sudo systemctl stop nom_service
```

Arrête le service immédiatement.

### Redémarrer un service

```bash
sudo systemctl restart nom_service
```

Arrête puis redémarre. Utile après modification de configuration.

### Recharger la configuration

```bash
sudo systemctl reload nom_service
```

Recharge la config **sans redémarrer** (si le service le supporte).

Si incertain, utilisez :

```bash
sudo systemctl reload-or-restart nom_service
```

## Activer/Désactiver au démarrage

### Activer (enable)

```bash
sudo systemctl enable nom_service
```

Le service démarrera **automatiquement au boot**.

### Désactiver (disable)

```bash
sudo systemctl disable nom_service
```

Le service ne démarrera **plus automatiquement** (mais peut être lancé manuellement).

### Enable + Start en une commande

```bash
sudo systemctl enable --now nom_service
```

Active ET démarre immédiatement.

### Disable + Stop en une commande

```bash
sudo systemctl disable --now nom_service
```

Désactive ET arrête immédiatement.

## Masquer un service

**Masquer** empêche complètement un service d'être lancé :

```bash
# Masquer
sudo systemctl mask nom_service

# Tenter de démarrer échoue
sudo systemctl start nom_service

# Démasquer
sudo systemctl unmask nom_service
```

Utile pour empêcher un service problématique de démarrer.

## Exemple pratique avec cron

Le service **cron** gère les tâches planifiées.

### État actuel

```bash
systemctl status cron
```

### Arrêter cron

```bash
sudo systemctl stop cron
systemctl status cron
```

L'état devrait être **inactive (dead)**.

### Démarrer cron

```bash
sudo systemctl start cron
systemctl status cron
```

L'état devrait être **active (running)**.

### Redémarrer cron

```bash
sudo systemctl restart cron
systemctl status cron
```

### Vérifier s'il est activé au boot

```bash
systemctl is-enabled cron
```

Devrait afficher **enabled**.

## Exemple avec nginx (serveur web)

Installons et gérons nginx :

```bash
# Installer nginx
sudo apt update
sudo apt install -y nginx
```

### Vérifier l'installation

```bash
systemctl status nginx
```

Nginx devrait être **active (running)**.

### Tester dans le navigateur

```bash
# Vérifier qu'il écoute sur le port 80
sudo ss -tlnp | grep :80

# Tester avec curl
curl localhost
```

Vous devriez voir la page HTML par défaut de nginx.

### Arrêter nginx

```bash
sudo systemctl stop nginx
systemctl is-active nginx
```

Devrait afficher **inactive**.

Tester à nouveau :

```bash
curl localhost
```

Erreur de connexion : nginx est bien arrêté.

### Redémarrer nginx

```bash
sudo systemctl start nginx
curl localhost
```

Fonctionne à nouveau !

### Recharger la configuration

Modifions un fichier de config :

```bash
# Éditer la config
sudo nano /etc/nginx/sites-available/default

# Recharger (pas de coupure de service)
sudo systemctl reload nginx

# Vérifier
systemctl status nginx
```

## Créer un service personnalisé

Créons un service simple pour apprendre.

### 1. Créer le script

```bash
sudo nano /usr/local/bin/mon_service.sh
```

Contenu :

```bash
#!/bin/bash
while true; do
    echo "Mon service tourne : $(date)" >> /tmp/mon_service.log
    sleep 10
done
```

Rendre exécutable :

```bash
sudo chmod +x /usr/local/bin/mon_service.sh
```

### 2. Créer le fichier .service

```bash
sudo nano /etc/systemd/system/mon_service.service
```

Contenu :

```ini
[Unit]
Description=Mon service de test
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/mon_service.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### 3. Recharger systemd

Après création/modification, recharger :

```bash
sudo systemctl daemon-reload
```

### 4. Gérer le service

```bash
# Démarrer
sudo systemctl start mon_service

# Vérifier
systemctl status mon_service

# Voir les logs
tail -f /tmp/mon_service.log

# Arrêter (Ctrl+C pour sortir de tail)
sudo systemctl stop mon_service

# Activer au boot
sudo systemctl enable mon_service

# Vérifier
systemctl is-enabled mon_service
```

## Redémarrage automatique

Les services peuvent redémarrer automatiquement en cas de crash :

```ini
[Service]
Restart=always        # Toujours redémarrer
# ou
Restart=on-failure    # Seulement en cas d'échec
# ou
Restart=on-abnormal   # Seulement si arrêt anormal
```

## Services et ressources

Limiter les ressources d'un service :

```ini
[Service]
MemoryLimit=512M
CPUQuota=50%
TasksMax=50
```

Exemple :

```bash
sudo nano /etc/systemd/system/mon_service.service
```

Ajouter dans [Service] :

```ini
MemoryLimit=100M
CPUQuota=20%
```

Puis :

```bash
sudo systemctl daemon-reload
sudo systemctl restart mon_service
systemctl show mon_service | grep -i memory
```

## Tableau récapitulatif des commandes

| Commande | Action |
|----------|--------|
| `systemctl start service` | Démarre |
| `systemctl stop service` | Arrête |
| `systemctl restart service` | Redémarre |
| `systemctl reload service` | Recharge config |
| `systemctl status service` | État détaillé |
| `systemctl enable service` | Active au boot |
| `systemctl disable service` | Désactive au boot |
| `systemctl enable --now service` | Active + démarre |
| `systemctl is-active service` | Est actif ? |
| `systemctl is-enabled service` | Est activé ? |
| `systemctl mask service` | Masque complètement |
| `systemctl unmask service` | Démasque |
| `systemctl daemon-reload` | Recharge systemd |

## Exercice pratique

1. Vérifiez que nginx est installé et en cours :

```bash
systemctl status nginx
```

2. Arrêtez nginx :

```bash
sudo systemctl stop nginx
```

3. Vérifiez qu'il est bien arrêté :

```bash
systemctl is-active nginx
```

4. Redémarrez nginx :

```bash
sudo systemctl start nginx
```

5. Créez le fichier de validation :

```bash
touch ~/services_geres
```

Excellent ! Passons maintenant à la consultation des logs pour déboguer les problèmes.
