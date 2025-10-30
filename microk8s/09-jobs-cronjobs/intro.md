# Bienvenue dans l'Exercice 8 : Jobs et CronJobs

## 🎯 Objectifs

Dans cet exercice, vous allez apprendre à :

- ✅ Créer et exécuter des **Jobs** (tâches run-to-completion)
- ✅ Configurer des **CronJobs** pour planifier des tâches
- ✅ Gérer les **échecs et retry** avec backoffLimit
- ✅ Consulter les **logs de jobs terminés**
- ✅ Exécuter des **jobs parallèles** avec completions et parallelism
- ✅ Suspendre et reprendre des CronJobs

## 🎓 Jobs vs CronJobs

### Job
Un **Job** crée un ou plusieurs Pods et s'assure qu'un nombre spécifié se termine avec succès :
- **Run-to-completion** : Le Job se termine quand la tâche est finie
- **Retry automatique** : Relance en cas d'échec (backoffLimit)
- **Usage unique** : Une exécution, puis terminé

### CronJob
Un **CronJob** crée des Jobs selon un planning (format cron) :
- **Planification** : Exécution périodique (toutes les heures, tous les jours, etc.)
- **Création automatique** : Crée un nouveau Job à chaque exécution
- **Historique** : Conserve un historique des exécutions réussies et échouées

## 🚀 Cas d'Usage

### Jobs
- **Migrations de base de données** : Exécuter une migration avant un déploiement
- **Batch processing** : Traiter un lot de données
- **Tests d'intégration** : Exécuter des tests automatisés
- **Import/Export** : Importer ou exporter des données

### CronJobs
- **Backups** : Sauvegarder la base de données toutes les nuits
- **Cleanup** : Nettoyer les fichiers temporaires chaque semaine
- **Rapports** : Générer des rapports quotidiens
- **Synchronisation** : Synchroniser des données toutes les heures

## 🛠️ Environnement

- Ubuntu 22.04 avec Microk8s
- kubectl configuré

## ⏱️ Durée Estimée

25 minutes

## 🚀 C'est Parti !

Attendez que l'environnement soit prêt (vous verrez "✅ Ready!"), puis cliquez sur **Start**.
