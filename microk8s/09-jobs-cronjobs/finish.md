# 🎉 Félicitations !

Vous avez terminé l'exercice sur les **Jobs** et **CronJobs** !

## 📚 Ce que vous avez appris

### Jobs
- ✅ Créer des Jobs **run-to-completion**
- ✅ Gérer les **échecs et retry** avec backoffLimit
- ✅ Consulter les **logs de jobs terminés**
- ✅ Configurer `restartPolicy` (Never, OnFailure)

### Jobs Parallèles
- ✅ Utiliser `completions` et `parallelism`
- ✅ Mode **Indexed** avec $JOB_COMPLETION_INDEX
- ✅ Observer la progression des Jobs
- ✅ Ajuster le parallélisme en cours d'exécution

### CronJobs
- ✅ Comprendre la **syntaxe cron**
- ✅ Planifier des tâches **récurrentes**
- ✅ Gérer l'**historique** des exécutions
- ✅ Suspendre et reprendre des CronJobs
- ✅ Exécuter manuellement un CronJob

## 🎯 Jobs vs CronJobs

| Job | CronJob |
|-----|---------|
| **Exécution unique** | **Exécution récurrente** |
| Run-to-completion | Crée des Jobs selon un planning |
| Créé manuellement | Créé automatiquement |
| Usage : migrations, batch | Usage : backups, cleanup, rapports |

## 🏆 Bonnes Pratiques

### ✅ À FAIRE

#### Jobs
- Utiliser `backoffLimit` pour limiter les tentatives
- Définir `activeDeadlineSeconds` pour un timeout global
- Utiliser `ttlSecondsAfterFinished` pour cleanup automatique
- Rendre les Jobs **idempotents** (peut être exécuté plusieurs fois)
- Utiliser `restartPolicy: OnFailure` pour retry dans le même Pod

#### Jobs Parallèles
- Adapter `parallelism` à la capacité du cluster
- Utiliser `completionMode: Indexed` pour traiter des partitions
- Monitorer la progression avec `kubectl get jobs -w`

#### CronJobs
- Utiliser `concurrencyPolicy: Forbid` pour éviter les exécutions simultanées
- Définir `successfulJobsHistoryLimit` et `failedJobsHistoryLimit`
- Rendre les tâches **idempotentes** (peuvent être exécutées plusieurs fois ou sautées)
- Utiliser `suspend: true` pour maintenance temporaire
- Définir `timeZone` explicitement (Kubernetes 1.27+)
- Tester avec `kubectl create job --from=cronjob/<name>`

### ❌ À ÉVITER

- Ne pas utiliser `restartPolicy: Always` pour les Jobs
- Ne pas oublier de nettoyer les Jobs terminés
- Éviter des Jobs trop longs (utiliser activeDeadlineSeconds)
- Ne pas dépendre de l'exécution exacte des CronJobs (peuvent être sautés)
- Éviter les CronJobs trop fréquents (< 1 minute peut causer des problèmes)

## 📊 Configuration Avancée

### Job avec Timeout
```yaml
spec:
  activeDeadlineSeconds: 600  # Timeout 10 minutes
  backoffLimit: 3
  ttlSecondsAfterFinished: 100  # Supprimé 100s après la fin
```

### CronJob avec Politique de Concurrence
```yaml
spec:
  schedule: "0 2 * * *"
  concurrencyPolicy: Forbid  # ou Allow, Replace
  startingDeadlineSeconds: 200  # Si raté, max 200s de retard
  suspend: false
```

Options de `concurrencyPolicy` :
- **Allow** (défaut) : Plusieurs Jobs peuvent tourner en parallèle
- **Forbid** : Si un Job tourne encore, skip le suivant
- **Replace** : Arrête le Job en cours et lance le nouveau

## 🚀 Exemples Réels

### 1. Migration de Base de Données

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
spec:
  backoffLimit: 0  # Pas de retry (migration doit être idempotente)
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: migrate
        image: myapp:latest
        command: ["./migrate.sh"]
        env:
        - name: DB_HOST
          value: postgres-service
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
```

### 2. Backup Quotidien PostgreSQL

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: postgres-backup
spec:
  schedule: "0 2 * * *"  # 2h du matin
  successfulJobsHistoryLimit: 7
  concurrencyPolicy: Forbid
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
              pg_dump -h postgres-service -U admin -d mydb | \
              gzip > /backups/backup-$(date +%Y%m%d).sql.gz
            volumeMounts:
            - name: backups
              mountPath: /backups
          volumes:
          - name: backups
            persistentVolumeClaim:
              claimName: backup-pvc
```

### 3. Cleanup des Logs (Hebdomadaire)

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: cleanup-logs
spec:
  schedule: "0 0 * * 0"  # Dimanche minuit
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: cleanup
            image: busybox:1.36
            command:
            - sh
            - -c
            - |
              echo "Nettoyage des logs de plus de 30 jours..."
              find /var/log -type f -name "*.log" -mtime +30 -delete
              echo "Nettoyage terminé"
            volumeMounts:
            - name: logs
              mountPath: /var/log
          volumes:
          - name: logs
            hostPath:
              path: /var/log
```

### 4. Batch Processing Parallèle

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: process-images
spec:
  completions: 100        # 100 images à traiter
  parallelism: 10         # 10 workers en parallèle
  completionMode: Indexed
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: processor
        image: image-processor:latest
        command:
        - sh
        - -c
        - |
          # $JOB_COMPLETION_INDEX = 0 à 99
          echo "Traitement de l'image $JOB_COMPLETION_INDEX"
          ./process-image.sh $JOB_COMPLETION_INDEX
```

## 📖 Commandes à Retenir

```bash
# Jobs
kubectl get jobs
kubectl describe job <name>
kubectl logs job/<name>
kubectl delete job <name>
kubectl wait --for=condition=complete job/<name>

# CronJobs
kubectl get cronjobs
kubectl describe cronjob <name>
kubectl create job <name> --from=cronjob/<cronjob-name>  # Exécution manuelle
kubectl patch cronjob <name> -p '{"spec":{"suspend":true}}'  # Suspendre
kubectl patch cronjob <name> -p '{"spec":{"suspend":false}}' # Reprendre

# Debug
kubectl get pods --selector=job-name=<job-name>
kubectl logs <pod-name>
kubectl describe pod <pod-name>
```

## 🧹 Nettoyage

Si vous voulez nettoyer les ressources créées :

```bash
microk8s kubectl delete job --all
microk8s kubectl delete cronjob --all
```{{exec}}

## 🎓 Prochaine Étape

Dans le prochain exercice, vous apprendrez les techniques de **Troubleshooting** pour diagnostiquer et résoudre les problèmes dans Kubernetes.

**Bravo pour votre travail ! 🚀**
