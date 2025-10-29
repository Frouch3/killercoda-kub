# Félicitations !

Vous avez terminé le scénario sur la gestion des processus et services sous Linux !

## Ce que vous avez appris

### Surveillance des processus
- **ps** : Lister les processus
- **top** : Monitoring en temps réel
- **htop** : Interface améliorée
- **pstree** : Arborescence des processus
- Comprendre PID, PPID, %CPU, %MEM, état

### Gestion des processus
- **kill** : Envoyer des signaux (TERM, KILL, HUP)
- **killall** : Tuer par nom
- **pkill** : Tuer par motif
- Avant/arrière-plan : jobs, fg, bg
- **nohup** et **disown** : Détacher des processus
- **nice** et **renice** : Gérer les priorités

### systemd et services
- Comprendre systemd (init moderne)
- **systemctl status** : État d'un service
- **systemctl list-units** : Lister les services
- Comprendre les unités (.service, .target, .timer)
- Dépendances entre services
- Fichiers de configuration dans /lib/systemd/system/

### Gestion des services
- **systemctl start/stop** : Démarrer/arrêter
- **systemctl restart/reload** : Redémarrer/recharger
- **systemctl enable/disable** : Activer au boot
- **systemctl mask/unmask** : Masquer complètement
- Créer un service personnalisé
- Limiter les ressources d'un service

### Consultation des logs
- **journalctl** : Outil centralisé de logs
- Filtrage par service : `-u service`
- Filtrage temporel : `--since`, `--until`
- Filtrage par priorité : `-p err/warning`
- Suivi en temps réel : `-f`
- Gestion de l'espace : `--vacuum-size`
- Débogage efficace des problèmes

## Commandes essentielles à retenir

```bash
# Processus
ps aux                          # Tous les processus
top                             # Monitoring temps réel
htop                            # Interface améliorée
pgrep nom                       # Trouver PID par nom
kill -15 PID                    # Terminer proprement
kill -9 PID                     # Tuer brutalement
killall nom                     # Tuer tous du même nom

# Services
systemctl status service        # État d'un service
systemctl start service         # Démarrer
systemctl stop service          # Arrêter
systemctl restart service       # Redémarrer
systemctl reload service        # Recharger config
systemctl enable service        # Activer au boot
systemctl disable service       # Désactiver au boot
systemctl enable --now service  # Activer + démarrer
systemctl list-units --type=service  # Lister services

# Logs
journalctl                      # Tous les logs
journalctl -u service           # Logs d'un service
journalctl -f                   # Temps réel
journalctl -n 50                # 50 dernières lignes
journalctl --since "1h ago"    # Dernière heure
journalctl -p err               # Erreurs seulement
journalctl -b                   # Boot actuel
journalctl --disk-usage         # Taille des logs
```

## Workflow de débogage

Quand un service ne fonctionne pas :

1. **Vérifier l'état** :
   ```bash
   systemctl status service
   ```

2. **Consulter les logs** :
   ```bash
   journalctl -u service -n 50
   ```

3. **Chercher les erreurs** :
   ```bash
   journalctl -u service -p err
   ```

4. **Redémarrer si nécessaire** :
   ```bash
   sudo systemctl restart service
   ```

5. **Suivre en temps réel** :
   ```bash
   journalctl -u service -f
   ```

## Bonnes pratiques

1. **Toujours vérifier les logs** avant et après modification
2. **Utiliser reload** plutôt que restart quand possible
3. **Tester les fichiers de config** avant de recharger
4. **Limiter les ressources** des services non critiques
5. **Nettoyer régulièrement les logs** anciens
6. **Documenter** les services personnalisés
7. **Utiliser systemd-analyze** pour optimiser le boot

## Pour aller plus loin

### Services avancés
- **Timers systemd** : Remplacer cron
- **Socket activation** : Démarrage à la demande
- **Slice et cgroups** : Gestion fine des ressources
- **Drop-in files** : Personnaliser sans modifier les fichiers originaux

### Monitoring avancé
- **netdata** : Dashboard de monitoring en temps réel
- **prometheus** + **grafana** : Monitoring et alerting
- **atop** : Analyse de performance avancée
- **perf** : Profiling kernel

### Logs avancés
- **Centralisation** : rsyslog, syslog-ng
- **Analyse** : ELK stack (Elasticsearch, Logstash, Kibana)
- **Alerting** : logwatch, fail2ban

## Ressources utiles

- `man systemctl` : Manuel complet de systemctl
- `man journalctl` : Manuel de journalctl
- `man systemd.service` : Format des fichiers service
- `systemctl --help` : Aide rapide
- [freedesktop.org/systemd](https://www.freedesktop.org/wiki/Software/systemd/)

## Scénarios de dépannage courants

### Service qui ne démarre pas

```bash
sudo systemctl status service
sudo journalctl -u service -p err
# Vérifier la config
sudo service --test-config  # Si supporté
```

### Service qui crash

```bash
# Voir pourquoi il s'est arrêté
journalctl -u service --since "1 hour ago"
# Vérifier les ressources
systemctl show service | grep -i memory
```

### Système lent

```bash
top                    # Identifier processus gourmands
systemd-analyze blame  # Temps de démarrage des services
journalctl -p warning  # Problèmes potentiels
```

## Prochaines étapes

Continuez votre apprentissage avec :
- **Scénario 07** : Configuration réseau de base
- **Scénario 08** : Scripts et automatisation

La maîtrise des processus et services est **essentielle** pour tout administrateur système. Ces compétences vous seront utiles au quotidien !

Merci d'avoir suivi ce scénario et bon courage pour la suite !
