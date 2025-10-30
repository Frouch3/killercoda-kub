#!/bin/bash

# Vérifier que les fichiers YAML ont été créés
if [ ! -f nginx-statefulset.yaml ]; then
  echo "❌ Fichier nginx-statefulset.yaml non trouvé"
  exit 1
fi

# Vérifier que les PVC ont été créés (même si StatefulSet supprimé)
PVC_COUNT=$(microk8s kubectl get pvc --no-headers 2>/dev/null | grep -c "data-nginx-stateful" || echo "0")
if [ "$PVC_COUNT" -eq 0 ]; then
  echo "❌ Aucun PVC créé pour le StatefulSet nginx"
  echo "Assurez-vous d'avoir créé et déployé le StatefulSet"
  exit 1
fi

# Vérifier que le fichier Deployment a été créé
if [ ! -f nginx-deployment.yaml ]; then
  echo "❌ Fichier nginx-deployment.yaml non trouvé"
  echo "Assurez-vous d'avoir créé le Deployment pour comparaison"
  exit 1
fi

echo "✅ Étape 1 complétée avec succès !"
echo "Vous avez compris la différence entre Deployment et StatefulSet"
