# Étape 4 : Simuler des Défaillances Réelles

## 📝 Objectif

Tester différents scénarios de défaillance et observer comment les probes réagissent.

## 🧪 Scénario 1 : App qui Devient Lente (Memory Leak)

Une application qui consomme de plus en plus de mémoire et devient lente :

```bash
cat > app-memory-leak.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: memory-leak-demo
spec:
  containers:
  - name: app
    image: python:3.9-slim
    command:
    - python3
    - -c
    - |
      import time
      import http.server
      import socketserver
      from threading import Thread

      # Variable pour simuler une fuite mémoire
      memory_hog = []

      class HealthHandler(http.server.SimpleHTTPRequestHandler):
          def do_GET(self):
              # Health endpoint : lent si beaucoup de mémoire consommée
              response_time = len(memory_hog) / 1000
              if response_time > 2:
                  time.sleep(3)  # Trop lent → timeout liveness probe
              self.send_response(200)
              self.end_headers()
              self.wfile.write(b"OK")

      # Démarrer le serveur HTTP
      server = socketserver.TCPServer(("", 8080), HealthHandler)
      thread = Thread(target=server.serve_forever)
      thread.start()

      print("App started, leaking memory slowly...")
      # Simuler une fuite mémoire progressive
      while True:
          memory_hog.append("x" * 10000)  # Leak 10KB
          time.sleep(0.5)

    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
      timeoutSeconds: 2      # Timeout de 2s
      failureThreshold: 3
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f app-memory-leak.yaml
```{{exec}}

Observer le comportement (l'app finira par être redémarrée car trop lente) :
```bash
microk8s kubectl get pod memory-leak-demo --watch
```{{exec}}

Après quelques minutes, le pod sera **redémarré** car la probe timeout.

Appuyez sur **Ctrl+C**.

## 🧪 Scénario 2 : Database Connection Lost

App qui perd sa connexion DB (readiness échoue, liveness OK) :

```bash
cat > app-db-connection.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: db-connection-demo
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      # Simuler une connexion DB
      touch /tmp/db-connected
      touch /tmp/app-alive

      echo "App started with DB connection"
      sleep 30

      # Perdre la connexion DB
      rm -f /tmp/db-connected
      echo "⚠️  DB connection lost! Not ready, but still alive"

      # App reste alive mais pas prête
      sleep 60

      # Reconnecter
      touch /tmp/db-connected
      echo "✅ DB reconnected, ready again"

      while true; do sleep 10; done

    # Liveness : App est-elle vivante ? (toujours OK)
    livenessProbe:
      exec:
        command: ["cat", "/tmp/app-alive"]
      periodSeconds: 5

    # Readiness : DB connectée ? (échoue temporairement)
    readinessProbe:
      exec:
        command: ["cat", "/tmp/db-connected"]
      periodSeconds: 5
      failureThreshold: 1
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f app-db-connection.yaml
```{{exec}}

Créer un Service :
```bash
microk8s kubectl expose pod db-connection-demo --port=80 --name=db-demo-svc
```{{exec}}

Observer :
```bash
microk8s kubectl get pod db-connection-demo --watch
```{{exec}}

Observez :
- **0-30s** : **READY 1/1** (DB connectée)
- **30-90s** : **READY 0/1** (DB perdue, pas de trafic, mais **pas de restart**)
- **90s+** : **READY 1/1** (DB reconnectée)

Appuyez sur **Ctrl+C**.

Vérifier les endpoints pendant la panne DB :
```bash
microk8s kubectl get endpoints db-demo-svc
```{{exec}}

Pendant la panne, l'endpoint est vide → **pas de trafic vers le pod**.

## 🧪 Scénario 3 : TCP Check pour une Base de Données

Simuler PostgreSQL avec une TCP probe :

```bash
cat > postgres-simulation.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: postgres-sim
spec:
  containers:
  - name: postgres
    image: postgres:15-alpine
    env:
    - name: POSTGRES_PASSWORD
      value: "secret"
    - name: POSTGRES_DB
      value: "mydb"

    # Liveness : Port 5432 ouvert ?
    livenessProbe:
      tcpSocket:
        port: 5432
      initialDelaySeconds: 30
      periodSeconds: 10

    # Readiness : Peut accepter des connexions ?
    readinessProbe:
      exec:
        command:
        - pg_isready
        - -U
        - postgres
      initialDelaySeconds: 5
      periodSeconds: 5
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f postgres-simulation.yaml
```{{exec}}

Attendre que PostgreSQL soit prêt :
```bash
microk8s kubectl wait --for=condition=Ready pod/postgres-sim --timeout=120s
```{{exec}}

Voir les probes en action :
```bash
microk8s kubectl describe pod postgres-sim | grep -A 5 "Liveness\|Readiness"
```{{exec}}

## 📊 Tableau Récapitulatif des Scénarios

| Scénario | Liveness | Readiness | Résultat |
|----------|----------|-----------|----------|
| **App normale** | ✅ Pass | ✅ Pass | Reçoit du trafic |
| **App en démarrage** | ⏳ Startup | ⏳ Startup | Pas encore de trafic |
| **App démarrée** | ✅ Pass | ✅ Pass | Reçoit du trafic |
| **DB déconnectée** | ✅ Pass | ❌ Fail | **Pas de trafic** (pas de restart) |
| **App bloquée (deadlock)** | ❌ Fail | ❌ Fail | **Restart** |
| **App lente (leak mémoire)** | ❌ Timeout | ❌ Timeout | **Restart** |

## 🎯 Bonnes Pratiques Résumées

### ✅ Toujours Utiliser les 3 Probes

```yaml
startupProbe:     # Pour les apps lentes au démarrage
  httpGet:
    path: /health/startup
  failureThreshold: 30
  periodSeconds: 10

livenessProbe:    # Pour auto-healing (crash, deadlock)
  httpGet:
    path: /health/live
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:   # Pour contrôler le trafic
  httpGet:
    path: /health/ready
  periodSeconds: 5
  failureThreshold: 2
```

### 📝 Endpoints Recommandés

| Endpoint | Vérifie | Exemple |
|----------|---------|---------|
| `/health/startup` | Fichiers chargés, cache initialisé | Symfony cache warm-up |
| `/health/live` | Processus tourne, pas de deadlock | Ping simple |
| `/health/ready` | DB connectée, dépendances OK | Check Redis, PostgreSQL, APIs |

### ⏱️ Timings Recommandés

```yaml
# App web légère (Nginx, API simple)
startupProbe:
  failureThreshold: 6
  periodSeconds: 5     # = 30s max
livenessProbe:
  periodSeconds: 10
readinessProbe:
  periodSeconds: 5

# App moyenne (Symfony, Django, Node.js)
startupProbe:
  failureThreshold: 12
  periodSeconds: 10    # = 120s (2 min) max
livenessProbe:
  periodSeconds: 10
readinessProbe:
  periodSeconds: 5

# App lourde (Java, base de données)
startupProbe:
  failureThreshold: 30
  periodSeconds: 10    # = 300s (5 min) max
livenessProbe:
  periodSeconds: 15
readinessProbe:
  periodSeconds: 10
```

## 🧹 Nettoyage (optionnel)

```bash
microk8s kubectl delete pod memory-leak-demo db-connection-demo postgres-sim --ignore-not-found
microk8s kubectl delete service db-demo-svc --ignore-not-found
```{{exec}}

---

Cliquez sur **Continue** pour terminer l'exercice.
