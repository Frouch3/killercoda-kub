# Étape 3 : CronJobs (Tâches Planifiées)

## 📝 Objectif

Planifier des tâches récurrentes avec **CronJobs**.

## 🎓 Qu'est-ce qu'un CronJob ?

Un **CronJob** crée automatiquement des Jobs selon un **planning** (format cron) :
- Exécution **périodique** : toutes les minutes, heures, jours, etc.
- Crée un nouveau **Job** à chaque exécution
- Gère l'**historique** des exécutions

## ⏰ Syntaxe Cron

Format : `* * * * *` (minute heure jour mois jour-semaine)

| Champ | Valeurs | Exemple |
|-------|---------|---------|
| Minute | 0-59 | `*/5` = toutes les 5 minutes |
| Heure | 0-23 | `2` = à 2h du matin |
| Jour | 1-31 | `15` = le 15 du mois |
| Mois | 1-12 | `*` = chaque mois |
| Jour semaine | 0-6 (0=dimanche) | `1` = lundi |

**Exemples** :
- `*/1 * * * *` → Toutes les minutes
- `0 */2 * * *` → Toutes les 2 heures
- `0 2 * * *` → Tous les jours à 2h du matin
- `0 0 * * 0` → Tous les dimanches à minuit
- `30 3 1 * *` → Le 1er de chaque mois à 3h30

## 📄 Créer un CronJob Simple

Créons un CronJob qui s'exécute **toutes les minutes** :

```bash
cat > hello-cronjob.yaml <<EOF
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello-cron
spec:
  # Toutes les minutes
  schedule: "*/1 * * * *"

  # Conserver l'historique des 3 derniers jobs réussis
  successfulJobsHistoryLimit: 3

  # Conserver l'historique des 3 derniers jobs échoués
  failedJobsHistoryLimit: 3

  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: hello
            image: busybox:1.36
            command:
            - sh
            - -c
            - |
              echo "=== CronJob exécuté ==="
              echo "Date: \$(date)"
              echo "Hostname: \$(hostname)"
              echo "======================="
EOF
```{{exec}}

Appliquer :
```bash
microk8s kubectl apply -f hello-cronjob.yaml
```{{exec}}

## 🔍 Observer les Exécutions

Voir le CronJob :
```bash
microk8s kubectl get cronjobs
```{{exec}}

Colonnes importantes :
- **SCHEDULE** : Le planning cron
- **SUSPEND** : Est-ce que le CronJob est suspendu ?
- **ACTIVE** : Nombre de Jobs actifs (en cours)
- **LAST SCHEDULE** : Dernière exécution

Attendre 2-3 minutes, puis voir les Jobs créés :
```bash
microk8s kubectl get jobs --selector=job-name
```{{exec}}

Vous verrez plusieurs Jobs : `hello-cron-28367850`, `hello-cron-28367851`, etc.

Voir les Pods :
```bash
microk8s kubectl get pods --selector=job-name
```{{exec}}

## 📋 Consulter les Logs

```bash
# Récupérer le dernier Pod créé
LAST_POD=$(microk8s kubectl get pods --selector=job-name --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}')

# Voir les logs
microk8s kubectl logs $LAST_POD
```{{exec}}

## 🛑 Suspendre un CronJob

Pour **arrêter temporairement** les exécutions sans supprimer le CronJob :

```bash
microk8s kubectl patch cronjob hello-cron -p '{"spec":{"suspend":true}}'
```{{exec}}

Vérifier :
```bash
microk8s kubectl get cronjob hello-cron
```{{exec}}

La colonne **SUSPEND** devrait afficher `True`.

## ▶️ Reprendre un CronJob

Pour reprendre les exécutions :

```bash
microk8s kubectl patch cronjob hello-cron -p '{"spec":{"suspend":false}}'
```{{exec}}

## 🗄️ Historique des Exécutions

Les CronJobs conservent un historique limité :

```yaml
successfulJobsHistoryLimit: 3  # 3 derniers jobs réussis
failedJobsHistoryLimit: 3      # 3 derniers jobs échoués
```

Les Jobs plus anciens sont **automatiquement supprimés**.

## 🧪 CronJob de Backup (Exemple Réaliste)

Créons un CronJob qui simule une sauvegarde quotidienne :

```bash
cat > backup-cronjob.yaml <<EOF
apiVersion: batch/v1
kind: CronJob
metadata:
  name: database-backup
spec:
  # Tous les jours à 2h du matin
  schedule: "0 2 * * *"

  successfulJobsHistoryLimit: 7  # Garder 7 jours d'historique
  failedJobsHistoryLimit: 3

  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: backup
            image: postgres:15-alpine
            command:
            - sh
            - -c
            - |
              echo "🔄 Début du backup..."
              echo "Date: \$(date)"
              # Simulation : pg_dump --host=postgres-service --dbname=mydb > backup.sql
              sleep 5
              echo "✅ Backup terminé avec succès"
              echo "Fichier: backup-\$(date +%Y%m%d-%H%M%S).sql"
EOF
```{{exec}}

Appliquer :
```bash
microk8s kubectl apply -f backup-cronjob.yaml
```{{exec}}

Pour tester **immédiatement** sans attendre le planning :
```bash
microk8s kubectl create job test-backup --from=cronjob/database-backup
```{{exec}}

Voir les logs :
```bash
microk8s kubectl logs job/test-backup
```{{exec}}

## 🎯 Cas d'Usage Réels

### Backup Quotidien
```yaml
schedule: "0 2 * * *"  # 2h du matin
# + script pg_dump ou mysqldump
```

### Cleanup Hebdomadaire
```yaml
schedule: "0 0 * * 0"  # Dimanche minuit
# + script de nettoyage des logs/fichiers temporaires
```

### Rapport Mensuel
```yaml
schedule: "0 9 1 * *"  # 1er du mois à 9h
# + script de génération de rapport
```

### Synchronisation Horaire
```yaml
schedule: "0 * * * *"  # Toutes les heures
# + script de sync de données
```

## 🧹 Nettoyer

```bash
microk8s kubectl delete cronjob hello-cron database-backup
microk8s kubectl delete job test-backup
```{{exec}}

## 🎯 Points Clés

- ✅ `schedule: "*/1 * * * *"` → Format cron (minute heure jour mois jour-semaine)
- ✅ `successfulJobsHistoryLimit: 3` → Historique des jobs réussis
- ✅ `failedJobsHistoryLimit: 3` → Historique des jobs échoués
- ✅ `suspend: true` → Suspendre temporairement
- ✅ `kubectl create job --from=cronjob/<name>` → Exécuter manuellement
- ✅ Les CronJobs créent des Jobs, qui créent des Pods

## ⚠️ Attention

- **Concurrence** : Par défaut, si un Job n'est pas terminé, un nouveau peut démarrer. Utilisez `concurrencyPolicy: Forbid` pour empêcher ça.
- **Timezone** : Par défaut UTC. Utilisez `timeZone: "Europe/Paris"` (Kubernetes 1.27+).
- **Idempotence** : Les CronJobs peuvent s'exécuter **plusieurs fois** ou être **sautés**. Rendez vos scripts idempotents.

---

Cliquez sur **Continue** pour le récapitulatif final.
