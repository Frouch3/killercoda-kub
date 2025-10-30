# Étape 3 : Startup Probe - Applications Lentes

## 📝 Objectif

Configurer une **Startup Probe** pour gérer les applications avec un démarrage lent.

## 🎓 Qu'est-ce qu'une Startup Probe ?

Une **Startup Probe** vérifie si le conteneur a **terminé son démarrage**.

**Tant que la Startup Probe n'a pas réussi** :
- ❌ **Liveness et Readiness sont désactivées**
- ✅ Le conteneur a **plus de temps** pour démarrer

**Cas d'usage** :
- Applications **Java/JVM** (chargement lent des classes)
- **Bases de données** (restauration, indexation au démarrage)
- Applications avec **migration** au démarrage
- **Gros frameworks** (Symfony, Django avec cache warm-up)

## 🚫 Problème Sans Startup Probe

Imaginons une app qui prend **60 secondes** à démarrer :

```yaml
livenessProbe:
  httpGet:
    path: /health
  initialDelaySeconds: 10  # Trop court !
  periodSeconds: 5
  failureThreshold: 3
```

**Problème** : Après 10s, la liveness probe commence, et échoue 3 fois avant que l'app soit prête.
→ **Kubernetes redémarre le pod** → **Boucle infinie de restarts** !

## ✅ Solution : Startup Probe

```yaml
startupProbe:
  httpGet:
    path: /health
  failureThreshold: 30      # 30 tentatives
  periodSeconds: 10         # Toutes les 10 secondes
  # = 300 secondes max pour démarrer (5 minutes)

livenessProbe:
  httpGet:
    path: /health
  periodSeconds: 5
  failureThreshold: 3
  # Ne démarre QUE après le succès de startupProbe
```

## 📄 Créer une App avec Démarrage Lent

```bash
cat > startup-slow-app.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: slow-startup
  labels:
    app: slow
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Starting slow application..."
      echo "This app takes 60 seconds to start..."

      # Simuler un démarrage lent (chargement, migration, cache)
      for i in \$(seq 1 12); do
        echo "Startup progress: \$((i * 5))/60 seconds..."
        sleep 5
      done

      # App prête
      touch /tmp/ready
      echo "✅ App fully started and ready!"

      # Rester actif
      while true; do sleep 10; done

    # Startup Probe : Permet jusqu'à 90 secondes pour démarrer
    startupProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      failureThreshold: 18     # 18 tentatives
      periodSeconds: 5         # Toutes les 5 secondes
      # = 90 secondes max

    # Liveness Probe : Ne s'active qu'APRÈS le succès de startupProbe
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      periodSeconds: 10
      failureThreshold: 3

    # Readiness Probe : Idem, ne s'active qu'après startupProbe
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      periodSeconds: 5
      failureThreshold: 2
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f startup-slow-app.yaml
```{{exec}}

## 👀 Observer le Démarrage

Suivre l'état du pod en temps réel :
```bash
microk8s kubectl get pod slow-startup --watch
```{{exec}}

Observez :
- **0-60s** : Status **Running**, mais **READY = 0/1** (en démarrage)
- **~60s** : Status passe à **READY = 1/1**
- **RESTARTS = 0** (pas de restart intempestif !)

Appuyez sur **Ctrl+C**.

Voir les logs :
```bash
microk8s kubectl logs slow-startup
```{{exec}}

Voir les événements :
```bash
microk8s kubectl describe pod slow-startup | tail -20
```{{exec}}

## 🧪 Comparaison : Avec vs Sans Startup Probe

### Sans Startup Probe (va crasher !)

```bash
cat > startup-without.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: no-startup-probe
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "App starting (60 seconds)..."
      sleep 60
      touch /tmp/ready
      while true; do sleep 10; done

    # PAS de startupProbe, liveness démarre trop tôt !
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      initialDelaySeconds: 10  # Trop court !
      periodSeconds: 5
      failureThreshold: 3      # 3 échecs = restart après 25s
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f startup-without.yaml
```{{exec}}

Observer (va redémarrer en boucle !) :
```bash
microk8s kubectl get pod no-startup-probe --watch
```{{exec}}

Le pod **redémarre en boucle** car la liveness probe échoue avant que l'app soit prête !

Appuyez sur **Ctrl+C**.

Voir les restarts :
```bash
microk8s kubectl get pod no-startup-probe
```{{exec}}

Colonne **RESTARTS** augmente constamment.

## 📊 Calcul des Timeouts

### Formule
```
Temps max de démarrage = failureThreshold × periodSeconds
```

### Exemples

| failureThreshold | periodSeconds | Temps max | Usage |
|------------------|---------------|-----------|-------|
| 6 | 10 | 60s | App légère |
| 12 | 10 | 120s (2 min) | App moyenne |
| 30 | 10 | 300s (5 min) | App très lente, DB |
| 60 | 5 | 300s (5 min) | Check fréquent |

## 🎯 Points Clés

- ✅ **Startup Probe** = "A-t-il fini de démarrer ?"
- ✅ **Bloque** liveness/readiness pendant le démarrage
- ✅ Évite les **restarts en boucle** pour apps lentes
- ✅ Calculez : `failureThreshold × periodSeconds` ≥ temps de démarrage
- ✅ Une fois réussi, **liveness/readiness prennent le relais**

## 📝 Bonnes Pratiques

### App Rapide (< 10s)
```yaml
# Pas besoin de startupProbe
livenessProbe:
  httpGet:
    path: /health
  initialDelaySeconds: 5
  periodSeconds: 5
```

### App Moyenne (10-60s)
```yaml
startupProbe:
  httpGet:
    path: /health
  failureThreshold: 12
  periodSeconds: 5
  # = 60 secondes max

livenessProbe:
  httpGet:
    path: /health
  periodSeconds: 10
```

### App Lente (> 60s)
```yaml
startupProbe:
  httpGet:
    path: /health
  failureThreshold: 30
  periodSeconds: 10
  # = 300 secondes (5 min) max

livenessProbe:
  httpGet:
    path: /health
  periodSeconds: 10
```

---

Cliquez sur **Continue** pour simuler des défaillances réelles.
