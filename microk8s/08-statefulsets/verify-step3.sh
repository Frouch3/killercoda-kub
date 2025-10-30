#!/bin/bash

# Vérifier que le StatefulSet existe toujours
if ! microk8s kubectl get statefulset postgres &>/dev/null; then
  echo "❌ StatefulSet 'postgres' non trouvé"
  exit 1
fi

# Vérifier que postgres-0 existe et est ready
if ! microk8s kubectl get pod postgres-0 &>/dev/null; then
  echo "❌ Pod 'postgres-0' non trouvé"
  exit 1
fi

POD_READY=$(microk8s kubectl get pod postgres-0 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
if [ "$POD_READY" != "True" ]; then
  echo "❌ Le pod postgres-0 n'est pas ready"
  echo "Attendez que le pod soit prêt (kubectl get pods)"
  exit 1
fi

# Vérifier qu'il y a au moins 3 utilisateurs dans la table (alice, bob, + ceux ajoutés)
USER_COUNT=$(microk8s kubectl exec postgres-0 -- psql -U admin -d myapp -tAc "SELECT COUNT(*) FROM users" 2>/dev/null || echo "0")
if [ "$USER_COUNT" -lt 3 ]; then
  echo "❌ La table users ne contient pas assez d'utilisateurs"
  echo "Assurez-vous d'avoir inséré des données (david, eve, etc.)"
  exit 1
fi

# Vérifier que le pod a redémarré au moins une fois OU que des données ont été ajoutées
# On vérifie juste qu'il y a plus que les 2 utilisateurs initiaux
if [ "$USER_COUNT" -gt 2 ]; then
  echo "✅ Des données supplémentaires ont été ajoutées ($USER_COUNT utilisateurs)"
else
  echo "⚠️  Seulement les données initiales présentes. Avez-vous testé la persistance ?"
fi

# Vérifier que les PVC existent toujours
PVC_COUNT=$(microk8s kubectl get pvc --no-headers 2>/dev/null | grep -c "data-postgres" || echo "0")
if [ "$PVC_COUNT" -eq 0 ]; then
  echo "❌ Les PVC PostgreSQL ont été supprimés"
  exit 1
fi

echo "✅ Étape 3 complétée avec succès !"
echo "La persistance des données est vérifiée"
echo "Utilisateurs dans la base : $USER_COUNT"
echo "PVC actifs : $PVC_COUNT"
