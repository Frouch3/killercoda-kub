# Gestion des processus et services sous Linux

Bienvenue dans ce scénario de formation sur la gestion des processus et des services !

## Objectifs de cette formation

À la fin de ce scénario, vous serez capable de :

- **Lister et surveiller** les processus en cours avec ps, top et htop
- **Gérer les processus** : envoyer des signaux, arrêter des processus
- **Comprendre systemd** : le système d'initialisation moderne de Linux
- **Gérer les services** avec systemctl (start, stop, restart, enable, disable)
- **Consulter les logs** système avec journalctl
- **Déboguer** les problèmes de services

## Concepts clés

### Processus
Un **processus** est un programme en cours d'exécution. Chaque processus a :
- Un **PID** (Process ID) unique
- Un utilisateur propriétaire
- Une consommation de ressources (CPU, mémoire)
- Un état (running, sleeping, stopped, zombie)

### Services
Un **service** (ou daemon) est un processus qui tourne en arrière-plan :
- Démarré automatiquement au boot
- Géré par systemd
- Exemples : SSH, Apache, MySQL, cron

## Pourquoi c'est important ?

La gestion des processus et services est essentielle pour :
- Surveiller les performances du système
- Déboguer les problèmes
- Optimiser l'utilisation des ressources
- Administrer les serveurs de production

## Prérequis

- Connaissances de base en ligne de commande Linux
- Avoir suivi le scénario sur les utilisateurs et permissions

## Durée estimée

35 à 45 minutes

Commençons par découvrir les processus en cours d'exécution !
