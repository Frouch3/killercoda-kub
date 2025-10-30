# Étape 4 : Problèmes Réseau et DNS

## 📝 Objectif

Diagnostiquer et résoudre des problèmes de communication entre pods et de résolution DNS.

## 🎓 DNS dans Kubernetes

Kubernetes fournit un serveur DNS interne (CoreDNS) :

**Format des noms de service** :
- Même namespace : `<service-name>`
- Autre namespace : `<service-name>.<namespace>`
- FQDN : `<service-name>.<namespace>.svc.cluster.local`

## 📄 Créer un Backend et un Frontend

### Backend avec Service

```bash
cat > backend.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: backend
  labels:
    app: backend
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
microk8s kubectl apply -f backend.yaml
```{{exec}}

### Frontend (Client)

```bash
cat > frontend.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  containers:
  - name: client
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
EOF
```{{exec}}

```bash
microk8s kubectl apply -f frontend.yaml
```{{exec}}

Attendre que les pods soient prêts :
```bash
microk8s kubectl get pods
```{{exec}}

## 🔍 Tester la Communication

### 1. Tester la résolution DNS

Depuis le frontend, résoudre le nom du service :
```bash
microk8s kubectl exec frontend -- nslookup backend-service
```{{exec}}

Vous devriez voir l'IP du service (ClusterIP).

### 2. Tester la connexion HTTP

```bash
microk8s kubectl exec frontend -- wget -qO- backend-service
```{{exec}}

Vous devriez voir le HTML de la page nginx.

### 3. Tester avec FQDN

```bash
microk8s kubectl exec frontend -- nslookup backend-service.default.svc.cluster.local
```{{exec}}

## 🚨 Scénario : Service Cassé (Mauvais Selector)

Créons un service avec un selector incorrect :

```bash
cat > broken-service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: broken-service
spec:
  selector:
    app: this-label-does-not-exist
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
microk8s kubectl apply -f broken-service.yaml
```{{exec}}

### Diagnostiquer

Tester depuis le frontend :
```bash
microk8s kubectl exec frontend -- wget -qO- --timeout=2 broken-service
```{{exec}}

Timeout ! Pourquoi ?

### Vérifier les Endpoints

Un Service sans endpoints est inutile :
```bash
microk8s kubectl get endpoints broken-service
```{{exec}}

Aucun endpoint ! Le selector ne matche aucun pod.

Comparer avec le service qui fonctionne :
```bash
microk8s kubectl get endpoints backend-service
```{{exec}}

Vous voyez l'IP du pod backend.

### Voir les détails du Service

```bash
microk8s kubectl describe service broken-service
```{{exec}}

Notez :
- Selector : `app=this-label-does-not-exist`
- Endpoints : `<none>`

## 🔧 Corriger le Service

```bash
cat > broken-service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: broken-service
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
microk8s kubectl apply -f broken-service.yaml
```{{exec}}

Vérifier les endpoints :
```bash
microk8s kubectl get endpoints broken-service
```{{exec}}

Maintenant il y a un endpoint ! Tester :
```bash
microk8s kubectl exec frontend -- wget -qO- broken-service
```{{exec}}

## 🧪 Scénario : DNS Ne Fonctionne Pas

Si DNS ne fonctionne pas du tout, vérifier CoreDNS :

```bash
microk8s kubectl get pods -n kube-system | grep coredns
```{{exec}}

Voir les logs de CoreDNS :
```bash
microk8s kubectl logs -n kube-system -l k8s-app=kube-dns
```{{exec}}

Tester la résolution depuis un pod :
```bash
microk8s kubectl exec frontend -- cat /etc/resolv.conf
```{{exec}}

Vous devriez voir le ClusterIP du service kube-dns.

## 🎯 Points Clés

- ✅ `kubectl exec <pod> -- nslookup <service>` : Tester DNS
- ✅ `kubectl exec <pod> -- wget/curl <service>` : Tester connectivité HTTP
- ✅ `kubectl get endpoints <service>` : Vérifier que le service a des pods backend
- ✅ `kubectl describe service` : Voir selector et endpoints
- ✅ Les services utilisent des **selectors** pour trouver les pods
- ✅ Si pas d'endpoints, vérifier les labels des pods vs selector du service

## 💡 Commandes de Debug Réseau

Vérifier les labels d'un pod :
```bash
microk8s kubectl get pod backend --show-labels
```{{exec}}

Tester directement l'IP d'un pod :
```bash
POD_IP=$(microk8s kubectl get pod backend -o jsonpath='{.status.podIP}')
microk8s kubectl exec frontend -- wget -qO- $POD_IP
```{{exec}}

Voir tous les services et leurs endpoints :
```bash
microk8s kubectl get endpoints
```{{exec}}

## 🧹 Nettoyage Optionnel

```bash
microk8s kubectl delete -f backend.yaml -f frontend.yaml -f broken-service.yaml
```{{exec}}

---

Cliquez sur **Continue** quand vous avez résolu les problèmes réseau.
