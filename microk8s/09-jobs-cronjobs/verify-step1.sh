#!/bin/bash

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin

# Vérifier que le Job pi-calculator existe ou a existé
if ! microk8s kubectl get job pi-calculator >/dev/null 2>&1; then
  echo "❌ Le Job 'pi-calculator' n'existe pas."
  echo "💡 Créez-le avec : microk8s kubectl apply -f pi-job.yaml"
  exit 1
fi

# Vérifier que le Job est terminé avec succès ou en cours
JOB_STATUS=$(microk8s kubectl get job pi-calculator -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}' 2>/dev/null)

if [ "$JOB_STATUS" != "True" ]; then
  # Vérifier si le job est toujours en cours
  ACTIVE=$(microk8s kubectl get job pi-calculator -o jsonpath='{.status.active}' 2>/dev/null)
  if [ -n "$ACTIVE" ] && [ "$ACTIVE" -gt 0 ]; then
    echo "⏳ Le Job 'pi-calculator' est en cours d'exécution. Attendez qu'il se termine..."
    exit 1
  else
    echo "❌ Le Job 'pi-calculator' n'est pas terminé avec succès."
    echo "💡 Vérifiez les logs avec : microk8s kubectl describe job pi-calculator"
    exit 1
  fi
fi

echo "✅ Job créé et exécuté correctement!"
