# Étape 2 : Readiness Probe - Gestion du Trafic

## 📝 Objectif

Configurer une **Readiness Probe** pour contrôler quand un pod reçoit du trafic.

## 🎓 Qu'est-ce qu'une Readiness Probe ?

Une **Readiness Probe** vérifie si le conteneur est **prêt** à recevoir du trafic.

**Si la probe échoue** → Le pod est **retiré du Service** (pas de trafic, mais **pas de restart**)

**Cas d'usage** :
- Application en **démarrage** (chargement cache, connexion DB)
- Dépendances temporairement **indisponibles** (DB saturée, API externe down)
- **Maintenance** (vidage du cache, warm-up)

## 🔍 Différence Liveness vs Readiness

| Liveness | Readiness |
|----------|-----------|
| **"Est-ce vivant ?"** | **"Est-ce prêt ?"** |
| Échec → **RESTART** | Échec → **PAS de trafic** |
| Problème **interne** fatal | Problème **externe** temporaire |
| Crash, deadlock | DB down, cache froid |

## 📄 Créer une App avec Readiness Probe

```bash
cat > readiness-app.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: readiness-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: readiness
  template:
    metadata:
      labels:
        app: readiness
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=Ready to serve traffic!"
        - "-listen=:8080"
        ports:
        - containerPort: 8080

        # Readiness Probe
        readinessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 3
          failureThreshold: 2
          successThreshold: 1

        # Liveness Probe (toujours recommandé en plus de readiness)
        livenessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: readiness-svc
spec:
  selector:
    app: readiness
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f readiness-app.yaml
```{{exec}}

## 🔍 Observer la Readiness

Voir les pods :
```bash
microk8s kubectl get pods -l app=readiness
```{{exec}}

Notez la colonne **READY** : `1/1` signifie que 1 conteneur sur 1 est **ready**.

Voir les endpoints du Service :
```bash
microk8s kubectl get endpoints readiness-svc
```{{exec}}

Vous voyez les **IPs des 3 pods** → tous reçoivent du trafic.

## 🧪 Simuler un Pod "Not Ready"

Créons un pod qui devient "not ready" après 30 secondes :

```bash
cat > readiness-toggle.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: readiness-toggle
  labels:
    app: readiness-toggle
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      # Créer le fichier "ready"
      mkdir -p /tmp
      touch /tmp/ready
      echo "App is READY for 30 seconds..."
      sleep 30

      # Devenir "not ready" (mais ne pas crasher !)
      rm -f /tmp/ready
      echo "App is NOT READY (overloaded, waiting for cache...)"
      sleep 30

      # Redevenir ready
      touch /tmp/ready
      echo "App is READY again!"

      # Rester alive
      while true; do sleep 10; done

    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      initialDelaySeconds: 2
      periodSeconds: 5
      failureThreshold: 1  # 1 seul échec = not ready

    livenessProbe:
      exec:
        command:
        - echo
        - "alive"
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f readiness-toggle.yaml
```{{exec}}

Créer un Service :
```bash
microk8s kubectl expose pod readiness-toggle --port=80 --target-port=8080 --name=toggle-svc
```{{exec}}

## 👀 Observer le Comportement

Suivre l'état du pod :
```bash
microk8s kubectl get pod readiness-toggle --watch
```{{exec}}

Observez la colonne **READY** :
- **0-30s** : `1/1` (READY)
- **30-60s** : `0/1` (**NOT READY**, mais status = **Running**)
- **60s+** : `1/1` (READY à nouveau)

**Important** : Le pod **ne redémarre PAS** ! Il reste **Running** mais ne reçoit pas de trafic.

Appuyez sur **Ctrl+C**.

## 🔍 Vérifier les Endpoints

Pendant que le pod est "not ready" :
```bash
microk8s kubectl get endpoints toggle-svc
```{{exec}}

Quand le pod est **not ready**, l'endpoint est **vide** → aucun trafic n'est envoyé.

## 🎯 Rolling Updates avec Readiness

La Readiness Probe est **critique** pour les Rolling Updates sans downtime :

```bash
# Voir le déploiement
microk8s kubectl get deployment readiness-demo
```{{exec}}

Simuler une mise à jour :
```bash
microk8s kubectl set image deployment/readiness-demo app=hashicorp/http-echo:latest
```{{exec}}

Observer le rollout :
```bash
microk8s kubectl rollout status deployment/readiness-demo
```{{exec}}

Pendant le rollout, Kubernetes :
1. Crée un **nouveau pod**
2. Attend que la **Readiness Probe** passe au vert
3. **Ensuite seulement**, envoie du trafic au nouveau pod
4. Supprime l'ancien pod

→ **Zero downtime** garanti !

## 🎯 Points Clés

- ✅ **Readiness = Prêt ?** → Si non, **PAS de trafic** (pas de restart)
- ✅ Utilisez readiness pour **démarrages lents** (cache, connexions DB)
- ✅ Utilisez readiness pour **dépendances externes** (API down temporairement)
- ✅ **Toujours** combiner avec **liveness** probe
- ✅ `failureThreshold` bas (1-2) pour retirer rapidement du trafic

## 📊 Cas d'Usage Réels

### Symfony/PHP
```yaml
readinessProbe:
  httpGet:
    path: /health/ready  # Vérifie DB, cache, dépendances
    port: 9000
  initialDelaySeconds: 10  # Temps de warm-up PHP-FPM
```

### PostgreSQL
```yaml
readinessProbe:
  exec:
    command:
    - pg_isready
    - -U
    - postgres
  periodSeconds: 5
```

---

Cliquez sur **Continue** pour découvrir les Startup Probes.
