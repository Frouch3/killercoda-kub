# Étape 3 : Explorer Signoz Dashboard

En production, vous accéderiez au dashboard Signoz sur http://signoz-frontend:3301

## Fonctionnalités Signoz

### 📊 Metrics
- CPU, RAM, requêtes/sec
- Latences P50, P95, P99
- Taux d'erreur

### 🔍 Traces Distribuées
- Visualiser le parcours d'une requête
- Identifier les goulots d'étranglement
- Débugger les erreurs

### 📋 Logs
- Centralisation des logs
- Corrélation logs ↔ traces
- Recherche full-text

### 🚨 Alertes
- Configurer des seuils
- Notifications Slack/Email
- Incidents automatiques

```bash
# Générer du trafic pour voir des traces
for i in {1..100}; do
  microk8s kubectl exec -it deployment/demo-app -- wget -q -O- http://localhost:5678
  sleep 0.5
done
```{{exec}}

🎉 Observabilité complète déployée !
