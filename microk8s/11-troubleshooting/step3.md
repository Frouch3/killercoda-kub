# Étape 3 : Pod Pending (Ressources Insuffisantes)

## 📝 Objectif

Diagnostiquer et corriger un pod qui reste en état `Pending` à cause de demandes de ressources trop élevées.

## 🎓 Qu'est-ce qu'un Pod Pending ?

**Pending** signifie que le pod a été accepté par Kubernetes mais ne peut pas être schedulé :

**Causes courantes** :
- Ressources CPU/RAM insuffisantes sur les nœuds
- Demandes (requests) trop élevées
- Aucun nœud ne correspond aux sélecteurs (nodeSelector, taints/tolerations)
- Volume PVC non disponible

## 📄 Créer un Pod avec des Demandes Excessives

D'abord, voir les ressources disponibles :
```bash
microk8s kubectl describe node | grep -A 5 "Allocated resources"
```{{exec}}

Créer un pod qui demande plus que disponible :

```bash
cat > pending-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pending-app
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        memory: "1000Gi"
        cpu: "1000"
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f pending-pod.yaml
```{{exec}}

## 🔍 Observer le Problème

```bash
microk8s kubectl get pods
```{{exec}}

Le status reste `Pending`.

## 🕵️ Diagnostiquer

### 1. Describe pour voir pourquoi
```bash
microk8s kubectl describe pod pending-app
```{{exec}}

Dans les **Events**, vous verrez :
```
Warning  FailedScheduling  ... 0/1 nodes are available:
1 Insufficient memory, 1 Insufficient cpu.
```

### 2. Comparer avec les ressources disponibles

Voir les ressources totales du nœud :
```bash
microk8s kubectl describe node | grep -E "Capacity|Allocatable" -A 5
```{{exec}}

Voir ce qui est déjà utilisé :
```bash
microk8s kubectl top node
```{{exec}}

### 3. Voir tous les pods et leurs ressources
```bash
microk8s kubectl get pods -A -o custom-columns=NAME:.metadata.name,CPU_REQ:.spec.containers[*].resources.requests.cpu,MEM_REQ:.spec.containers[*].resources.requests.memory
```{{exec}}

## 🔧 Corriger le Problème

Réduire les demandes à des valeurs réalistes :

```bash
cat > pending-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pending-app
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
EOF
```{{exec}}

Supprimer et recréer :
```bash
microk8s kubectl delete pod pending-app
microk8s kubectl apply -f pending-pod.yaml
```{{exec}}

Vérifier :
```bash
microk8s kubectl get pod pending-app
```{{exec}}

Le pod devrait maintenant être `Running`.

## 🧪 Scénario 2 : NodeSelector Impossible

Créer un pod avec un nodeSelector qui ne matche aucun nœud :

```bash
cat > nodeselector-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nodeselector-app
spec:
  nodeSelector:
    disktype: ssd-nvme-ultra-fast
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
microk8s kubectl apply -f nodeselector-pod.yaml
```{{exec}}

Diagnostiquer :
```bash
microk8s kubectl describe pod nodeselector-app
```{{exec}}

Events :
```
Warning  FailedScheduling  ... 0/1 nodes are available:
1 node(s) didn't match Pod's node affinity/selector.
```

Voir les labels des nœuds :
```bash
microk8s kubectl get nodes --show-labels
```{{exec}}

Nettoyage :
```bash
microk8s kubectl delete pod nodeselector-app
```{{exec}}

## 🎯 Points Clés

- ✅ `kubectl describe pod` : Message clair du scheduler
- ✅ `kubectl describe node` : Voir ressources disponibles
- ✅ `kubectl top node` : Utilisation en temps réel
- ✅ Requests vs Limits : Requests = garanties, Limits = max
- ✅ Le scheduler utilise les **requests**, pas les limits

## 📊 Comprendre Requests vs Limits

```yaml
resources:
  requests:       # Ce que le pod DEMANDE (garanti)
    cpu: "100m"   # 0.1 CPU (10% d'un core)
    memory: "64Mi"
  limits:         # Ce que le pod peut UTILISER au max
    cpu: "200m"   # 0.2 CPU max
    memory: "128Mi"
```

- **Requests** : Utilisées par le scheduler pour placer le pod
- **Limits** : Si dépassées, le pod peut être throttled (CPU) ou killed (RAM)

## 💡 Commandes Utiles

Voir l'utilisation réelle des pods :
```bash
microk8s kubectl top pods
```{{exec}}

Voir les ressources de tous les pods :
```bash
microk8s kubectl get pods -o custom-columns=NAME:.metadata.name,CPU:.spec.containers[0].resources.requests.cpu,MEM:.spec.containers[0].resources.requests.memory
```{{exec}}

---

Cliquez sur **Continue** quand vous avez résolu le Pod Pending.
