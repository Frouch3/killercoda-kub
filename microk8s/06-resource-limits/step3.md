# Étape 3 : Simuler OOMKilled

## 📝 Objectif

Observer ce qui se passe quand un pod dépasse sa limite mémoire.

## 💥 Créer un Pod qui Consomme Trop de RAM

```bash
cat > oom-demo.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: oom-killer
spec:
  containers:
  - name: memory-hog
    image: polinux/stress
    command: ["stress"]
    args:
    - "--vm"
    - "1"
    - "--vm-bytes"
    - "200M"    # Consommer 200 MB
    - "--vm-hang"
    - "0"
    resources:
      requests:
        memory: "50Mi"
      limits:
        memory: "100Mi"  # Limit trop basse !
EOF
```{{exec}}

```bash
microk8s kubectl apply -f oom-demo.yaml
```{{exec}}

## 👀 Observer le OOMKilled

```bash
microk8s kubectl get pod oom-killer --watch
```{{exec}}

Le pod sera **OOMKilled** puis redémarré en boucle.

Appuyez sur **Ctrl+C**.

## 🔍 Voir la Raison

```bash
microk8s kubectl describe pod oom-killer | grep -A 5 "Last State"
```{{exec}}

Vous verrez : **Reason: OOMKilled**

## 📊 Voir les Metrics (si Metrics Server activé)

```bash
microk8s kubectl top pod oom-killer 2>/dev/null || echo "Metrics Server non activé"
```{{exec}}

## 🎯 Bonnes Pratiques

### Valeurs Recommandées

**API/Web légère** :
```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

**App moyenne (Symfony)** :
```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

**Base de données** :
```yaml
resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "1000m"
```

---

Cliquez sur **Continue**.
