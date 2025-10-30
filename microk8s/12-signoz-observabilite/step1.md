# Étape 1 : Installer Signoz

Signoz est une alternative open-source à DataDog/New Relic.

```bash
# Installer Signoz via Helm
microk8s enable helm3
microk8s kubectl create namespace signoz

# Simuler l'installation (version simplifiée pour la démo)
cat > signoz-minimal.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: signoz-frontend
  namespace: signoz
spec:
  replicas: 1
  selector:
    matchLabels:
      app: signoz
  template:
    metadata:
      labels:
        app: signoz
    spec:
      containers:
      - name: frontend
        image: signoz/frontend:latest
        ports:
        - containerPort: 3301
---
apiVersion: v1
kind: Service
metadata:
  name: signoz-frontend
  namespace: signoz
spec:
  selector:
    app: signoz
  ports:
  - port: 3301
EOF
microk8s kubectl apply -f signoz-minimal.yaml
```{{exec}}

📝 Note : En production, utilisez le chart Helm complet de Signoz.

✅ Signoz en cours d'installation !
