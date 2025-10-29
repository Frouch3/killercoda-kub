# Étape 5 : Automatisation avec cron

## Introduction

**cron** est le planificateur de tâches de Linux. Il permet d'exécuter des scripts automatiquement à des moments précis.

## Le service cron

### Vérifier que cron est actif

```bash
systemctl status cron
```

Si inactif :

```bash
sudo systemctl start cron
sudo systemctl enable cron
```

## Syntaxe crontab

Une ligne crontab a 6 champs :

```
* * * * * commande
│ │ │ │ │
│ │ │ │ └─ Jour de la semaine (0-7, 0=dimanche, 7=dimanche aussi)
│ │ │ └─── Mois (1-12)
│ │ └───── Jour du mois (1-31)
│ └─────── Heure (0-23)
└───────── Minute (0-59)
```

### Exemples de syntaxe

| Expression | Signification |
|------------|---------------|
| `* * * * *` | Chaque minute |
| `0 * * * *` | Toutes les heures à la minute 0 |
| `0 0 * * *` | Tous les jours à minuit |
| `0 0 * * 0` | Tous les dimanches à minuit |
| `30 2 * * *` | Tous les jours à 2h30 |
| `0 9-17 * * *` | Toutes les heures entre 9h et 17h |
| `*/5 * * * *` | Toutes les 5 minutes |
| `0 0 1 * *` | Le 1er de chaque mois à minuit |
| `0 0 1 1 *` | Le 1er janvier à minuit |

## Gérer les crontabs

### Éditer sa crontab

```bash
crontab -e
```

Ouvre un éditeur pour modifier votre crontab.

### Voir sa crontab

```bash
crontab -l
```

### Supprimer sa crontab

```bash
crontab -r
```

### Crontab d'un autre utilisateur (root)

```bash
sudo crontab -u nom_utilisateur -e
sudo crontab -u nom_utilisateur -l
```

## Exemples pratiques

### Backup quotidien

```bash
# Tous les jours à 2h du matin
0 2 * * * /home/user/scripts/backup.sh
```

### Nettoyage hebdomadaire

```bash
# Tous les dimanches à 3h
0 3 * * 0 /home/user/scripts/cleanup.sh
```

### Mise à jour système

```bash
# Tous les lundis à 4h
0 4 * * 1 sudo apt update && sudo apt upgrade -y
```

### Surveillance toutes les 5 minutes

```bash
*/5 * * * * /home/user/scripts/check_service.sh
```

### Rapport mensuel

```bash
# Le 1er de chaque mois à 9h
0 9 1 * * /home/user/scripts/rapport_mensuel.sh
```

## Variables d'environnement dans crontab

Les crontabs ont un environnement limité. Définissez les variables :

```crontab
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=admin@example.com

0 2 * * * /home/user/scripts/backup.sh
```

## Redirection des sorties

### Ignorer la sortie

```crontab
0 2 * * * /home/user/scripts/backup.sh > /dev/null 2>&1
```

### Logger dans un fichier

```crontab
0 2 * * * /home/user/scripts/backup.sh >> /var/log/backup.log 2>&1
```

### Envoyer par email (si MAILTO configuré)

```crontab
MAILTO=admin@example.com
0 2 * * * /home/user/scripts/backup.sh
```

## Scripts adaptés à cron

### Bonnes pratiques

```bash
#!/bin/bash

# Chemins absolus
BACKUP_DIR="/var/backups"
SOURCE_DIR="/home/user/data"

# Log avec timestamp
LOG_FILE="/var/log/backup.log"
echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Démarrage backup" >> "$LOG_FILE"

# Gestion des erreurs
set -e

# Script principal
tar -czf "${BACKUP_DIR}/backup_$(date +%Y%m%d).tar.gz" "$SOURCE_DIR" 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Backup réussi" >> "$LOG_FILE"
else
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Backup échoué" >> "$LOG_FILE"
    exit 1
fi
```

## Script de backup automatique

```bash
#!/bin/bash
# /home/user/scripts/backup_auto.sh
# Backup automatique avec rotation

BACKUP_DIR="/var/backups/daily"
SOURCE_DIR="/home/user/important"
RETENTION_DAYS=7
LOG_FILE="/var/log/backup_auto.log"

# Fonction de log
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

log "=== Démarrage du backup ==="

# Créer le répertoire de backup
mkdir -p "$BACKUP_DIR"

# Nom du fichier avec timestamp
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Créer l'archive
log "Création de l'archive..."
if tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>> "$LOG_FILE"; then
    TAILLE=$(du -h "$BACKUP_FILE" | cut -f1)
    log "✓ Backup créé : $BACKUP_FILE ($TAILLE)"
else
    log "✗ Erreur lors de la création du backup"
    exit 1
fi

# Rotation : supprimer les backups de plus de 7 jours
log "Nettoyage des anciens backups..."
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete

NOMBRE_BACKUPS=$(ls -1 "$BACKUP_DIR" | wc -l)
log "Backups conservés : $NOMBRE_BACKUPS"

log "=== Backup terminé avec succès ==="
exit 0
```

Ajouter à crontab :

```bash
chmod +x /home/user/scripts/backup_auto.sh
crontab -e
```

Ajouter :

```crontab
# Backup tous les jours à 2h du matin
0 2 * * * /home/user/scripts/backup_auto.sh
```

## Script de surveillance

```bash
#!/bin/bash
# /home/user/scripts/check_service.sh
# Surveiller un service et le redémarrer si nécessaire

SERVICE="nginx"
LOG_FILE="/var/log/service_monitor.log"

log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" >> "$LOG_FILE"
}

# Vérifier si le service est actif
if ! systemctl is-active --quiet "$SERVICE"; then
    log "⚠ $SERVICE est arrêté, tentative de redémarrage..."

    sudo systemctl start "$SERVICE"

    if systemctl is-active --quiet "$SERVICE"; then
        log "✓ $SERVICE redémarré avec succès"
    else
        log "✗ Impossible de redémarrer $SERVICE"
        # Envoyer une alerte (email, webhook, etc.)
    fi
else
    log "✓ $SERVICE fonctionne normalement"
fi
```

Crontab (toutes les 5 minutes) :

```crontab
*/5 * * * * /home/user/scripts/check_service.sh
```

## Fichiers cron système

Les fichiers cron système sont dans :

### /etc/crontab

Fichier principal (format légèrement différent avec nom utilisateur) :

```bash
cat /etc/crontab
```

Exemple :

```
0 2 * * * root /path/to/script.sh
│ │ │ │ │  │    └─ Commande
│ │ │ │ │  └────── Utilisateur
└─┴─┴─┴─┴────────── Planification
```

### /etc/cron.d/

Fichiers de configuration cron :

```bash
ls /etc/cron.d/
```

### Répertoires temporels

Scripts exécutés automatiquement :

```bash
/etc/cron.hourly/   # Toutes les heures
/etc/cron.daily/    # Tous les jours
/etc/cron.weekly/   # Toutes les semaines
/etc/cron.monthly/  # Tous les mois
```

Pour ajouter un script :

```bash
sudo cp mon_script.sh /etc/cron.daily/
sudo chmod +x /etc/cron.daily/mon_script.sh
```

## systemd timers (alternative moderne)

**systemd timers** remplace progressivement cron.

### Créer un timer

Fichier `/etc/systemd/system/mon_backup.service` :

```ini
[Unit]
Description=Backup quotidien

[Service]
Type=oneshot
ExecStart=/home/user/scripts/backup_auto.sh
```

Fichier `/etc/systemd/system/mon_backup.timer` :

```ini
[Unit]
Description=Timer pour backup quotidien

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Activer :

```bash
sudo systemctl daemon-reload
sudo systemctl enable mon_backup.timer
sudo systemctl start mon_backup.timer
```

Vérifier :

```bash
systemctl list-timers
```

## Déboguer les crontabs

### Vérifier les logs cron

```bash
# Ubuntu/Debian
sudo grep CRON /var/log/syslog

# Fedora/RHEL
sudo journalctl -u crond
```

### Tester un script manuellement

```bash
# Exécuter comme si c'était cron
env -i /bin/bash --noprofile --norc /path/to/script.sh
```

### Vérifier la syntaxe crontab

```bash
# Installer cron-utils si disponible
crontab -l | crontab -T
```

## Exercice pratique

1. Créez un script de nettoyage :

```bash
cat > ~/cleanup.sh << 'EOF'
#!/bin/bash
# Nettoyage des fichiers temporaires

LOG="/tmp/cleanup.log"

echo "[$(date)] Nettoyage démarré" >> "$LOG"

# Supprimer fichiers .tmp de plus de 7 jours
find /tmp -name "*.tmp" -mtime +7 -delete 2>> "$LOG"

echo "[$(date)] Nettoyage terminé" >> "$LOG"
EOF

chmod +x ~/cleanup.sh
```

2. Testez le script :

```bash
~/cleanup.sh
cat /tmp/cleanup.log
```

3. Ajoutez-le à crontab (exécution toutes les heures) :

```bash
crontab -e
```

Ajoutez :

```crontab
0 * * * * /home/$(whoami)/cleanup.sh
```

4. Vérifiez la crontab :

```bash
crontab -l
```

5. Créez le fichier de validation :

```bash
touch ~/automatisation_ok
```

Félicitations ! Vous maîtrisez maintenant l'automatisation avec cron.

## Bonnes pratiques

1. **Toujours utiliser des chemins absolus** dans les scripts cron
2. **Logger** toutes les actions importantes
3. **Gérer les erreurs** (set -e, vérifier $?)
4. **Tester** manuellement avant d'automatiser
5. **Rediriger** stdout et stderr
6. **Documenter** les crontabs avec des commentaires
7. **Surveiller** les logs cron régulièrement
8. **Rotation** des fichiers de log
9. **Notifications** en cas d'erreur
10. **Sauvegardes** des crontabs importantes

Vous êtes maintenant prêt à automatiser efficacement vos tâches système !
