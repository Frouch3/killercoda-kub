# Étape 2 : Déployer Application

```bash
cat > php-app.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: php
  template:
    metadata:
      labels:
        app: php
    spec:
      containers:
      - name: php
        image: php:8.2-apache
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: php-service
spec:
  selector:
    app: php
  ports:
  - port: 80
EOF
microk8s kubectl apply -f php-app.yaml
microk8s kubectl wait --for=condition=Available deployment/php-app --timeout=120s
```{{exec}}

✅ Application déployée !
