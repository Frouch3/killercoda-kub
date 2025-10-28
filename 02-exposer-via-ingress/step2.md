# Étape 2 : Déployer l'Application

## 📝 Objectif

Déployer une application Nginx simple avec son Service.

## 📄 Créer le Deployment

```bash
cat > app-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.25-alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html
        configMap:
          name: web-content
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-content
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head><title>Application Web</title></head>
    <body>
      <h1>🚀 Application Web via Ingress</h1>
      <p>Cette page est servie via un Ingress Controller!</p>
      <p>Hostname: <span id="hostname"></span></p>
      <script>
        fetch('/api/hostname').catch(() => {
          document.getElementById('hostname').innerText = 'N/A';
        });
      </script>
    </body>
    </html>
EOF
```{{exec}}

## 🚀 Appliquer le Deployment

```bash
microk8s kubectl apply -f app-deployment.yaml
```{{exec}}

## 📄 Créer le Service

Un Service **ClusterIP** suffit car l'Ingress va s'en charger :

```bash
cat > app-service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
EOF
```{{exec}}

```bash
microk8s kubectl apply -f app-service.yaml
```{{exec}}

## ✅ Vérifier le Déploiement

```bash
microk8s kubectl get pods -l app=web
microk8s kubectl get svc web-service
```{{exec}}

## 🎯 Point Clé

Remarquez que le Service est de type **ClusterIP** (pas NodePort) :
- Il n'est **pas** accessible depuis l'extérieur directement
- Seul l'**Ingress Controller** peut l'atteindre
- C'est le pattern recommandé avec Ingress

---

Cliquez sur **Continue** pour créer l'Ingress.
