# 🎉 Félicitations !

Vous avez terminé l'exercice sur les **Health Checks et Probes** !

## 📚 Ce que vous avez appris

### Les 3 Types de Probes

| Probe | Objectif | Action si échec |
|-------|----------|-----------------|
| **Liveness** | Le conteneur fonctionne-t-il ? | **Redémarre** le conteneur |
| **Readiness** | Peut-il recevoir du trafic ? | **Retire** du Service |
| **Startup** | A-t-il fini de démarrer ? | Donne plus de temps |

### Cas d'Usage Réels

✅ **Liveness** : Détecte les deadlocks, crashes silencieux, fuites mémoire
✅ **Readiness** : Gère les démarrages, les dépendances temporairement indisponibles
✅ **Startup** : Évite les restarts en boucle pour les apps lentes

## 🎯 Points Clés à Retenir

### 🔍 Différences Fondamentales

```yaml
# Liveness : "Es-tu vivant ?"
# Échec → RESTART
livenessProbe:
  httpGet:
    path: /health/live
  periodSeconds: 10
  failureThreshold: 3

# Readiness : "Es-tu prêt ?"
# Échec → PAS de trafic (pas de restart)
readinessProbe:
  httpGet:
    path: /health/ready
  periodSeconds: 5
  failureThreshold: 2

# Startup : "As-tu fini de démarrer ?"
# En cours → Bloque liveness/readiness
startupProbe:
  httpGet:
    path: /health/startup
  failureThreshold: 30
  periodSeconds: 10
```

### 📊 Tableau de Décision

| Situation | Liveness | Readiness | Startup |
|-----------|----------|-----------|---------|
| **Démarrage normal** | ⏳ Bloqué | ⏳ Bloqué | 🔄 En cours |
| **App prête** | ✅ OK | ✅ OK | ✅ Succès |
| **DB déconnectée** | ✅ OK | ❌ Fail | - |
| **Deadlock** | ❌ Fail | ❌ Fail | - |
| **App trop lente** | ⏱️ Timeout | ⏱️ Timeout | - |

**Résultat** :
- Startup en cours → Pas de trafic, pas de restart
- Liveness fail → **RESTART**
- Readiness fail → **Pas de trafic** (mais pas de restart)

## 🏆 Bonnes Pratiques

### ✅ À FAIRE

1. **Toujours utiliser les 3 probes ensemble**
   ```yaml
   startupProbe + livenessProbe + readinessProbe
   ```

2. **Endpoints séparés pour chaque probe**
   - `/health/startup` : Vérifie initialisation complète
   - `/health/live` : Check simple et rapide (< 1s)
   - `/health/ready` : Vérifie DB, cache, dépendances

3. **Timings adaptés à votre app**
   - App légère : startup 30s, liveness 10s, readiness 5s
   - App moyenne : startup 2min, liveness 10s, readiness 5s
   - App lourde : startup 5min, liveness 15s, readiness 10s

4. **Utiliser failureThreshold >= 3**
   - Évite les restarts intempestifs sur un échec ponctuel

5. **Timeout raisonnable (1-2s)**
   - Les probes doivent être rapides
   - Ne testez PAS des opérations lourdes (queries lentes)

### ❌ À ÉVITER

1. ❌ **Pas de probe du tout**
   - Pod "Running" mais mort → trafic vers pod HS

2. ❌ **Liveness trop agressive**
   ```yaml
   livenessProbe:
     failureThreshold: 1  # ❌ Trop bas !
     periodSeconds: 3     # ❌ Trop fréquent !
   ```
   → Restarts intempestifs

3. ❌ **initialDelaySeconds trop court**
   - Sans startupProbe, risque de restart en boucle

4. ❌ **Probe qui teste la DB**
   ```yaml
   livenessProbe:
     exec:
       command: ["psql", "-c", "SELECT 1"]  # ❌ Trop lent !
   ```
   → Utilisez readinessProbe pour les dépendances externes

5. ❌ **Même endpoint pour liveness et readiness**
   - Liveness = santé interne (app vivante ?)
   - Readiness = santé externe (dépendances OK ?)

## 📖 Configuration Optimale par Type d'App

### API REST / Microservice
```yaml
startupProbe:
  httpGet:
    path: /health/startup
  failureThreshold: 6
  periodSeconds: 5

livenessProbe:
  httpGet:
    path: /health/live
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /health/ready  # Vérifie DB, Redis, APIs
  periodSeconds: 5
  failureThreshold: 2
```

### Application Symfony/PHP
```yaml
startupProbe:
  httpGet:
    path: /health/startup
  failureThreshold: 12
  periodSeconds: 10      # 2 minutes pour cache warm-up

livenessProbe:
  httpGet:
    path: /health/live   # Ping PHP-FPM
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /health/ready  # Vérifie PostgreSQL, Memcached
  periodSeconds: 5
  failureThreshold: 2
```

### Base de Données (PostgreSQL, MySQL)
```yaml
startupProbe:
  tcpSocket:
    port: 5432
  failureThreshold: 30
  periodSeconds: 10      # 5 minutes pour restauration

livenessProbe:
  tcpSocket:
    port: 5432
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:
  exec:
    command: ["pg_isready", "-U", "postgres"]
  periodSeconds: 5
  failureThreshold: 2
```

## 🚀 Impact sur les Déploiements

### Rolling Update avec Probes

1. Nouveau pod créé
2. **startupProbe** doit réussir
3. **readinessProbe** doit réussir
4. **Trafic envoyé** au nouveau pod
5. Ancien pod supprimé

**Résultat** : **Zero downtime** garanti !

### Sans Probes

1. Nouveau pod créé
2. ❌ Trafic immédiat (app pas prête)
3. ❌ Erreurs 502
4. ❌ Ancien pod supprimé (downtime)

## 🔧 Commandes Utiles

```bash
# Voir les probes configurées
kubectl describe pod <pod-name> | grep -A 10 "Liveness\|Readiness\|Startup"

# Voir les événements de probe failures
kubectl get events --field-selector involvedObject.name=<pod-name>

# Tester manuellement un endpoint
kubectl exec <pod> -- curl localhost:8080/health

# Forcer un restart (pour tester)
kubectl delete pod <pod-name>

# Voir le nombre de restarts
kubectl get pod <pod-name> -o jsonpath='{.status.containerStatuses[0].restartCount}'
```

## 🧹 Nettoyage

```bash
microk8s kubectl delete pod liveness-http liveness-crash readiness-toggle slow-startup no-startup-probe memory-leak-demo db-connection-demo postgres-sim --ignore-not-found
microk8s kubectl delete deployment readiness-demo --ignore-not-found
microk8s kubectl delete service readiness-svc toggle-svc db-demo-svc --ignore-not-found
```{{exec}}

---

## 🎓 Prochaine Étape

Dans le prochain exercice, vous apprendrez à gérer les **Resource Limits** (CPU et RAM) pour éviter qu'un pod ne consomme toutes les ressources du cluster.

**Bravo pour votre travail ! 🚀**
