# Étape 1 : Requests et Limits

## 📝 Concepts

### Requests
**Garantie minimale** de ressources réservées pour le pod.
- Utilisé par le **scheduler** pour placer le pod
- Toujours disponible pour le pod

### Limits
**Maximum** de ressources que le pod peut utiliser.
- CPU : Throttling (ralentissement)
- RAM : OOMKilled (pod tué)

## 📄 Créer un Pod avec Resources

```bash
cat > pod-with-resources.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        memory: "64Mi"   # Minimum garanti
        cpu: "250m"      # 0.25 CPU garanti
      limits:
        memory: "128Mi"  # Maximum autorisé
        cpu: "500m"      # 0.5 CPU max
EOF
```{{exec}}

```bash
microk8s kubectl apply -f pod-with-resources.yaml
```{{exec}}

## 🔍 Voir les Resources

```bash
microk8s kubectl describe pod resource-demo | grep -A 10 "Limits\|Requests"
```{{exec}}

## 📊 Unités

**CPU** :
- `1000m` = 1 CPU core
- `500m` = 0.5 CPU
- `100m` = 0.1 CPU

**Mémoire** :
- `Ki` = Kibibyte (1024)
- `Mi` = Mebibyte (1024²)
- `Gi` = Gibibyte (1024³)

---

Cliquez sur **Continue**.
