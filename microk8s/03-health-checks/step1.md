# Étape 1 : Liveness Probe - Auto-Healing

## 📝 Objectif

Configurer une **Liveness Probe** pour redémarrer automatiquement les conteneurs défaillants.

## 🎓 Qu'est-ce qu'une Liveness Probe ?

Une **Liveness Probe** vérifie si le conteneur est encore **vivant** et fonctionne correctement.

**Si la probe échoue** → Kubernetes **redémarre** le conteneur (auto-healing)

**Cas d'usage** :
- Application en **deadlock** (processus bloqué)
- Fuite mémoire qui rend l'app **non-responsive**
- Crash silencieux (processus tourne mais ne répond plus)

## 📄 Créer une App avec Liveness Probe

Créons une application qui simule un crash après 30 secondes :

```bash
cat > liveness-app.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: liveness-http
  labels:
    app: liveness-demo
spec:
  containers:
  - name: app
    image: hashicorp/http-echo
    args:
    - "-text=I'm alive!"
    - "-listen=:8080"
    ports:
    - containerPort: 8080

    # Liveness Probe : HTTP GET /health
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 10  # Attendre 10s avant la première vérification
      periodSeconds: 5         # Vérifier toutes les 5 secondes
      timeoutSeconds: 2        # Timeout de 2 secondes
      failureThreshold: 3      # 3 échecs consécutifs = restart
      successThreshold: 1      # 1 succès = considéré vivant
EOF
```{{exec}}

## 🔍 Paramètres Expliqués

| Paramètre | Valeur | Signification |
|-----------|--------|---------------|
| `initialDelaySeconds` | 10 | Attendre 10s après le démarrage du conteneur avant la 1ère probe |
| `periodSeconds` | 5 | Exécuter la probe toutes les 5 secondes |
| `timeoutSeconds` | 2 | La probe doit répondre en moins de 2 secondes |
| `failureThreshold` | 3 | 3 échecs consécutifs → RESTART |
| `successThreshold` | 1 | 1 succès suffit pour considérer vivant |

**Temps avant restart** : Si l'app crashe, elle sera redémarrée après **15 secondes max** (3 échecs × 5 sec)

## 🚀 Déployer l'Application

```bash
microk8s kubectl apply -f liveness-app.yaml
```{{exec}}

Attendre que le pod soit prêt :
```bash
microk8s kubectl wait --for=condition=Ready pod/liveness-http --timeout=60s
```{{exec}}

## 🔍 Observer la Liveness Probe

Voir les événements du pod :
```bash
microk8s kubectl describe pod liveness-http | grep -A 10 "Liveness:"
```{{exec}}

Voir l'état du pod :
```bash
microk8s kubectl get pod liveness-http
```{{exec}}

Le pod doit être **Running** avec **0 restarts**.

## 🧪 Simuler un Crash

Maintenant, simulons une app qui ne répond plus. Créons un pod qui crash volontairement :

```bash
cat > liveness-crash.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: liveness-crash
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      # Créer un fichier "healthy"
      touch /tmp/healthy
      echo "App started, healthy for 30 seconds..."

      # Simuler un fonctionnement normal pendant 30s
      sleep 30

      # Simuler un crash : supprimer le fichier healthy
      rm -f /tmp/healthy
      echo "App crashed! Health check will fail..."

      # Mais le processus continue de tourner (zombie app)
      while true; do sleep 1; done

    # Liveness Probe : Check si le fichier existe
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
      failureThreshold: 2  # 2 échecs = restart rapide
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f liveness-crash.yaml
```{{exec}}

## 👀 Observer le Redémarrage Automatique

Suivre les événements en temps réel :
```bash
microk8s kubectl get pod liveness-crash --watch
```{{exec}}

Vous verrez :
1. **0-30s** : Pod **Running**, RESTARTS = **0**
2. **30-40s** : Liveness probe échoue 2 fois
3. **~40s** : Pod **redémarre**, RESTARTS = **1**
4. Le cycle recommence !

Appuyez sur **Ctrl+C** pour arrêter le watch.

## 🔍 Voir les Événements de Restart

```bash
microk8s kubectl describe pod liveness-crash | tail -20
```{{exec}}

Vous verrez des événements comme :
- `Liveness probe failed: cat: can't open '/tmp/healthy': No such file or directory`
- `Container app failed liveness probe, will be restarted`

## 📊 Voir le Nombre de Restarts

```bash
microk8s kubectl get pod liveness-crash -o jsonpath='{.status.containerStatuses[0].restartCount}'
echo " restarts"
```{{exec}}

Le nombre augmente à chaque cycle !

## 🎯 Points Clés

- ✅ **Liveness = Vivant ?** → Si non, **RESTART**
- ✅ Utilisez `initialDelaySeconds` suffisant pour le démarrage de l'app
- ✅ `failureThreshold` trop bas = restarts intempestifs
- ✅ `failureThreshold` trop haut = détection lente des crashes
- ✅ Idéal : **3-5 échecs** avec `periodSeconds: 5-10`

## ⚠️ Attention

- ⚠️ **Ne testez PAS** la base de données avec une liveness probe (trop lent)
- ⚠️ Le endpoint `/health` doit être **rapide** (< 1 seconde)
- ⚠️ Ne redémarrez pas pour des erreurs **temporaires** (utilisez readiness)

---

Cliquez sur **Continue** pour découvrir les Readiness Probes.
