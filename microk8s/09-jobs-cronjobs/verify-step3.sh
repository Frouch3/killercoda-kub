#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le CronJob hello-cron existe
if ! microk8s kubectl get cronjob hello-cron >/dev/null 2>&1; then
  echo "❌ Le CronJob 'hello-cron' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl apply -f hello-cronjob.yaml"
  exit 1
fi

# Vérifier le schedule
SCHEDULE=$(microk8s kubectl get cronjob hello-cron -o jsonpath='{.spec.schedule}')

if [ "$SCHEDULE" != "*/1 * * * *" ]; then
  echo "❌ Le CronJob 'hello-cron' doit avoir schedule: '*/1 * * * *'"
  echo "💡 Valeur actuelle: $SCHEDULE"
  exit 1
fi

# Vérifier les historiques
SUCCESS_LIMIT=$(microk8s kubectl get cronjob hello-cron -o jsonpath='{.spec.successfulJobsHistoryLimit}')
FAILED_LIMIT=$(microk8s kubectl get cronjob hello-cron -o jsonpath='{.spec.failedJobsHistoryLimit}')

if [ "$SUCCESS_LIMIT" != "3" ]; then
  echo "⚠️  Recommandation : successfulJobsHistoryLimit devrait être 3"
fi

if [ "$FAILED_LIMIT" != "3" ]; then
  echo "⚠️  Recommandation : failedJobsHistoryLimit devrait être 3"
fi

echo "✅ CronJob créé correctement!"
