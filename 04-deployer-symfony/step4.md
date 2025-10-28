# Étape 4 : Déployer Symfony

```bash
cat > symfony-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: symfony-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: symfony
  template:
    metadata:
      labels:
        app: symfony
    spec:
      containers:
      - name: php-fpm
        image: dunglas/frankenphp
        envFrom:
        - configMapRef:
            name: symfony-config
---
apiVersion: v1
kind: Service
metadata:
  name: symfony-service
spec:
  selector:
    app: symfony
  ports:
  - port: 80
    targetPort: 80
EOF
microk8s kubectl apply -f symfony-deployment.yaml
microk8s kubectl wait --for=condition=Available deployment/symfony-app --timeout=120s
```{{exec}}

✅ Symfony déployé !
