# Étape 5 : Consulter les logs avec journalctl

## Introduction

Les logs sont **essentiels** pour comprendre ce qui se passe sur le système et déboguer les problèmes. systemd utilise **journald** pour centraliser tous les logs.

## journalctl : l'outil de consultation des logs

**journalctl** permet de consulter les logs du journal systemd.

### Voir tous les logs

```bash
sudo journalctl
```

Affiche **tous** les logs depuis le démarrage. Utilisez :
- **Espace** : Page suivante
- **b** : Page précédente
- **g** : Aller à la fin
- **q** : Quitter
- **/** : Rechercher

### Logs récents

```bash
# 20 dernières lignes
sudo journalctl -n 20

# 50 dernières lignes
sudo journalctl -n 50

# Équivalent à tail -f (suivi en temps réel)
sudo journalctl -f
```

## Filtrer par service

### Logs d'un service spécifique

```bash
# Logs de nginx
sudo journalctl -u nginx

# 30 dernières lignes de nginx
sudo journalctl -u nginx -n 30

# Suivre les logs nginx en temps réel
sudo journalctl -u nginx -f
```

### Plusieurs services

```bash
sudo journalctl -u nginx -u ssh
```

## Filtrer par temps

### Depuis un moment précis

```bash
# Depuis 1 heure
sudo journalctl --since "1 hour ago"

# Depuis 30 minutes
sudo journalctl --since "30 min ago"

# Depuis ce matin
sudo journalctl --since "today"

# Depuis hier
sudo journalctl --since "yesterday"

# Date précise
sudo journalctl --since "2024-10-29 10:00:00"
```

### Période spécifique

```bash
# Entre deux moments
sudo journalctl --since "2024-10-29 10:00" --until "2024-10-29 12:00"

# Dernières 2 heures
sudo journalctl --since "2 hours ago"
```

## Filtrer par priorité

Les logs ont des niveaux de priorité :

| Niveau | Code | Description |
|--------|------|-------------|
| emerg | 0 | Urgence système |
| alert | 1 | Action immédiate nécessaire |
| crit | 2 | Critique |
| err | 3 | Erreur |
| warning | 4 | Avertissement |
| notice | 5 | Notice normale |
| info | 6 | Information |
| debug | 7 | Debug |

### Afficher par priorité

```bash
# Erreurs et plus graves
sudo journalctl -p err

# Warnings et plus graves
sudo journalctl -p warning

# Uniquement les erreurs critiques
sudo journalctl -p crit
```

## Filtrer par boot

### Boot actuel

```bash
sudo journalctl -b
```

### Boots précédents

```bash
# Liste des boots
sudo journalctl --list-boots

# Boot précédent
sudo journalctl -b -1

# Boot il y a 2 redémarrages
sudo journalctl -b -2
```

## Combiner les filtres

Les filtres se combinent :

```bash
# Erreurs nginx aujourd'hui
sudo journalctl -u nginx -p err --since today

# Logs SSH de la dernière heure
sudo journalctl -u ssh --since "1 hour ago" -f

# Warnings de tous les services depuis ce matin
sudo journalctl -p warning --since today
```

## Format de sortie

### JSON

```bash
sudo journalctl -u nginx -n 5 -o json
```

### JSON compact

```bash
sudo journalctl -u nginx -n 5 -o json-pretty
```

### Court (syslog-style)

```bash
sudo journalctl -u nginx -n 10 -o short
```

### Verbeux

```bash
sudo journalctl -u nginx -n 5 -o verbose
```

## Rechercher dans les logs

### Grep

```bash
# Chercher "error" dans nginx
sudo journalctl -u nginx | grep -i error

# Chercher "failed" dans tous les logs
sudo journalctl --since today | grep -i failed
```

### Avec journalctl directement

```bash
# Chercher un motif (case-insensitive)
sudo journalctl -g "error|failed|warning"
```

## Taille et gestion des logs

### Voir la taille utilisée

```bash
sudo journalctl --disk-usage
```

### Nettoyer les anciens logs

```bash
# Garder seulement 2 jours
sudo journalctl --vacuum-time=2d

# Limiter à 500M
sudo journalctl --vacuum-size=500M

# Garder seulement 3 fichiers
sudo journalctl --vacuum-files=3
```

### Configuration permanente

Éditer `/etc/systemd/journald.conf` :

```bash
sudo nano /etc/systemd/journald.conf
```

Paramètres utiles :

```ini
[Journal]
SystemMaxUse=500M        # Taille max sur disque
SystemMaxFileSize=100M   # Taille max par fichier
MaxRetentionSec=1month   # Garder 1 mois
```

Appliquer :

```bash
sudo systemctl restart systemd-journald
```

## Déboguer un service qui ne démarre pas

### Exemple complet

```bash
# 1. Essayer de démarrer
sudo systemctl start nginx

# 2. Voir le statut
systemctl status nginx

# 3. Voir les logs détaillés
sudo journalctl -u nginx -n 50

# 4. Logs depuis la dernière tentative
sudo journalctl -u nginx --since "5 min ago"

# 5. Avec priorité erreur
sudo journalctl -u nginx -p err
```

## Logs kernel

### Logs du noyau Linux

```bash
# Voir les logs kernel
sudo journalctl -k

# Derniers logs kernel
sudo journalctl -k -n 30

# Équivalent de dmesg
dmesg | tail -50
```

## Logs par utilisateur

### Filtrer par UID

```bash
# Logs de l'utilisateur 1000
sudo journalctl _UID=1000

# Logs de root
sudo journalctl _UID=0
```

### Logs de connexion

```bash
# Authentifications
sudo journalctl -u systemd-logind

# Sessions SSH
sudo journalctl -u ssh | grep -i "accepted\|failed"
```

## Exporter les logs

### Vers un fichier

```bash
# Export complet
sudo journalctl > ~/logs_complets.txt

# Export d'un service
sudo journalctl -u nginx > ~/logs_nginx.txt

# Export depuis hier
sudo journalctl --since yesterday > ~/logs_hier.txt
```

## Persistance des logs

Par défaut sur Ubuntu, les logs sont **volatiles** (perdus au reboot).

### Rendre les logs persistants

```bash
# Créer le répertoire
sudo mkdir -p /var/log/journal

# Donner les bonnes permissions
sudo systemd-tmpfiles --create --prefix /var/log/journal

# Redémarrer journald
sudo systemctl restart systemd-journald

# Vérifier
sudo journalctl --list-boots
```

Maintenant les logs persistent entre les redémarrages.

## Cas pratiques de débogage

### Service qui crash au démarrage

```bash
sudo systemctl start monservice
sudo journalctl -u monservice -p err --since "1 min ago"
```

### Problème réseau

```bash
sudo journalctl -u systemd-networkd -f
```

### Authentifications échouées

```bash
sudo journalctl | grep -i "failed password"
sudo journalctl -u ssh | grep -i "failed"
```

### Erreurs critiques système

```bash
sudo journalctl -p crit --since today
```

## Exercice pratique

1. Consultez les logs de nginx :

```bash
sudo journalctl -u nginx -n 20
```

2. Suivez les logs système en temps réel pendant 10 secondes :

```bash
sudo timeout 10 journalctl -f
```

3. Cherchez les erreurs récentes :

```bash
sudo journalctl -p err --since "1 hour ago"
```

4. Vérifiez la taille des logs :

```bash
sudo journalctl --disk-usage
```

5. Créez le fichier de validation :

```bash
touch ~/logs_consultes
```

Excellent ! Vous maîtrisez maintenant la consultation des logs sous Linux.

## Commandes journalctl essentielles

```bash
# Consultation de base
journalctl                      # Tous les logs
journalctl -f                   # Temps réel
journalctl -n 50                # 50 dernières lignes

# Par service
journalctl -u service           # Service spécifique
journalctl -u service -f        # Service en temps réel

# Par temps
journalctl --since "1h ago"    # Dernière heure
journalctl --since today        # Aujourd'hui
journalctl -b                   # Boot actuel

# Par priorité
journalctl -p err              # Erreurs
journalctl -p warning          # Warnings

# Combinaisons
journalctl -u nginx -p err --since "1h ago"

# Gestion
journalctl --disk-usage        # Taille
journalctl --vacuum-size=500M  # Nettoyer
```

Félicitations ! Vous savez maintenant gérer les processus, services et logs sous Linux.
