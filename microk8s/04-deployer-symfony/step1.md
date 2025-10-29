# Étape 1 : Déployer PostgreSQL

## Créer StatefulSet PostgreSQL

```bash
cat > postgres.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  ports:
  - port: 5432
  clusterIP: None
  selector:
    app: postgres
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_DB
          value: symfony
        - name: POSTGRES_USER
          value: symfony
        - name: POSTGRES_PASSWORD
          value: symfony123
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
EOF
microk8s kubectl apply -f postgres.yaml
```{{exec}}

## Vérifier

```bash
microk8s kubectl wait --for=condition=Ready pod/postgres-0 --timeout=120s
microk8s kubectl exec postgres-0 -- psql -U symfony -c '\l'
```{{exec}}

✅ PostgreSQL prêt !
