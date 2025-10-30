#!/bin/bash

# Vérifier que le ConfigMap existe
if ! microk8s kubectl get configmap postgres-init &>/dev/null; then
  echo "❌ ConfigMap 'postgres-init' non trouvé"
  echo "Assurez-vous de créer le ConfigMap avec le script init.sql"
  exit 1
fi

# Vérifier que le Headless Service existe
if ! microk8s kubectl get service postgres &>/dev/null; then
  echo "❌ Headless Service 'postgres' non trouvé"
  exit 1
fi

# Vérifier que le service a clusterIP: None (headless)
CLUSTER_IP=$(microk8s kubectl get service postgres -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
if [ "$CLUSTER_IP" != "None" ]; then
  echo "❌ Le service 'postgres' n'est pas un Headless Service (clusterIP doit être None)"
  exit 1
fi

# Vérifier que le StatefulSet existe
if ! microk8s kubectl get statefulset postgres &>/dev/null; then
  echo "❌ StatefulSet 'postgres' non trouvé"
  exit 1
fi

# Vérifier que le StatefulSet a au moins 1 replica ready
READY_REPLICAS=$(microk8s kubectl get statefulset postgres -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [ "$READY_REPLICAS" -lt 1 ]; then
  echo "❌ Le StatefulSet postgres n'a aucun replica ready"
  echo "Attendez que les pods soient prêts (kubectl get pods -l app=postgres)"
  exit 1
fi

# Vérifier que les PVC ont été créés automatiquement
PVC_COUNT=$(microk8s kubectl get pvc --no-headers 2>/dev/null | grep -c "data-postgres" || echo "0")
if [ "$PVC_COUNT" -eq 0 ]; then
  echo "❌ Aucun PVC créé pour PostgreSQL"
  echo "Vérifiez les volumeClaimTemplates dans le StatefulSet"
  exit 1
fi

# Vérifier que PostgreSQL répond
if ! microk8s kubectl exec postgres-0 -- pg_isready -U admin &>/dev/null; then
  echo "❌ PostgreSQL ne répond pas sur postgres-0"
  echo "Vérifiez les logs : kubectl logs postgres-0"
  exit 1
fi

# Vérifier que la table users existe
TABLE_EXISTS=$(microk8s kubectl exec postgres-0 -- psql -U admin -d myapp -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_name='users'" 2>/dev/null || echo "0")
if [ "$TABLE_EXISTS" -eq 0 ]; then
  echo "❌ La table 'users' n'existe pas dans la base de données"
  echo "Vérifiez que le script d'initialisation a été exécuté"
  exit 1
fi

echo "✅ Étape 2 complétée avec succès !"
echo "PostgreSQL est déployé avec StatefulSet et stockage persistant"
echo "PVC créés : $PVC_COUNT"
echo "Replicas ready : $READY_REPLICAS"
